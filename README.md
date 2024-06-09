# re_open_chat

## 启动！

```
$ flutter pub get
$ dart build_runner build
```

然后直接跑就彳亍了

## 关于 Env

在 `/lib/env` 中新建 `.env` 文件，输入

```
# /lib/env/.env
BASE="localhost:8080"
VERSION_KEY="i don't know"
```

之后运行 `dart build_runner build` 即可

如果你需要运行 bloc test，需要再设置 `DEVICE_ID`

## 你最好需要知道的库

`flutter_bloc`、`freezed`、`json_serializable`

## `BLoC` 与 `freezed`

完整的 `BLoC` 中，需要分成 `Bloc`,`State`,`Event`三层，其中 `State` 应当是能够继承非常多个的，在不同的 `Event` 下，返回不同的 `State` 子类，但是这似乎在 `freezed` 中并不方便，于是乎 `State` 可以被看作为一个完全的 data class

<del> btw, 这样反而减轻了工作量</del>