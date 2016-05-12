# JsonQuery
given the example json as:
```
{
  "reference": [
    {
      "category":"exercise",
      "type":"expenditure",
      "activities":[
        {"name":"biking", "calories":550},
        {"name":"golf", "calories":1000},
        {"name":"running", "calories":650},
        {"name":"swimming", "calories":650},
        {"name":"walking", "calories":225}
      ]
    },
    {
      "category":"nutrition",
      "type":"intake",
      "fruit":[
        {"name":"apple", "calories":70},
        {"name":"banana", "calories":70},
        {"name":"orange", "calories":90}
      ],
      "vegetables":[
        {"name":"baked potato", "calories":150},
        {"name":"broccoli", "calories":50},
        {"name":"green beans", "calories":30}
      ]
    }
  ],
  "program": [
    {
      "category":"exercise",
      "schedule":[
        {"day":"sunday", "activity":"swimming"},
        {"day":"monday", "activity":"running"},
        {"day":"tuesday", "activity":"biking"},
        {"day":"wednesday", "activity":"running"},
        {"day":"thursday", "activity":"swimming"},
        {"day":"friday", "activity":"running"},
        {"day":"saturday", "activity":"golf"}
      ]
    },
    {
      "category":"diet",
      "schedule":[
      ]
    }
  ]
}
```
you can
```
nh = NestedHash.new(my_json)
nh.ls("*")
>>> ["profile", "reference", "category"]
nh.ls("*/*/category")
>>> ["reference/0/category", "reference/1/category", "program/0/category", "program/1/category"]
```

though, this only support if the object of an array, is similar
