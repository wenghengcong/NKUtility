#  print

打印 JSON :
```
e print(String(data: JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: data, options: []), options: .prettyPrinted), encoding: .utf8)!)
```

