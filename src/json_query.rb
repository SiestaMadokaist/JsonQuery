require "hashie"
require "memoist"

class HashQuery
  attr_reader(:path)
  # @param root [NestedHash]
  # @param query [String]
  def initialize(root, path)
    @root = root
    @path = path
  end

  def parent
    ps = @path.split("/")
    p = ps.take(ps.length - 2).join("/")
    HashQuery.new(@root, p)
  end

  def value
    @root[@path]
  end
end

class NestedHash

  def initialize(value)
    @value = Hashie::Mash[value]
    @query_count = 0
  end

  # @param qs [String]
  # e.g: a.ab.*.xs.*
  def ls(q)
    raise InvalidQuery if q.end_with?("/")
    qs = string_transformer(q)
    result = _query(qs, @value)
    return result if result.empty?
    test = result.first
    tc = test.count("/")
    qc = q.count("/")
    return result if qc == tc
    result
      .map{|r| "#{r}/#{qs.drop(r.split("/").length).join("/")}"}
      .map{|r| ls r}
      .flatten(1)
  end

  def item(path)
    HashQuery.new(self, path)
  end

  def items(path)
    ls(path).map{|p| item(p)}
  end

  def [](path)
    return @value if path.empty?
    def qloop(qs, root)
      head = qs.first
      tail = qs.drop(1)
      return root[head] if tail.empty?
      return qloop(tail, root[head])
    end
    qs = string_transformer(path)
    qloop(qs, @value)
  end

  private def string_transformer(s)
    # transforming string to symbol, and number to integer
    # not yet handling floating point key
    # TODO: handle floating point key
    s.split("/").map{|x| x.match(/\A\d+(?:\.\d+)*\z/).nil? ? x.to_sym : x.to_i}
  end

  private def _query(queries, root, accumulative = [])
    head = queries.first
    tail = queries.drop(1)
    if(head == :*)
      parent = accumulative.map(&:to_s).join("/")
      parent_value = self[parent]
      if(parent_value.class == Array)
        (0..root.length - 1).map{|x| [parent, x].select{|x| x != ""}.join("/")}
      elsif(parent_value.class == Hashie::Mash)
        parent_value.keys.map{|x| [parent, x].select{|x| x != "" }.join("/")}
      else
        []
      end
    elsif(head.nil?)
     [accumulative.map(&:to_s).join("/")]
    else
      _query(tail, root[head], accumulative + [head])
    end
  end
end
