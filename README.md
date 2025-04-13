# Shinar

```
rails generate scaffold user name:string
```

```
rails generate scaffold chat token:string creator:references subject:string
```

```
rails generate scaffold chat_user chat:references user:references
```

```
rails generate scaffold message chat:references author:references content:text parent:references
```
