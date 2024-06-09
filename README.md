# re_open_chat

这次用了 BLoC 进行状态管理，迁移到了移动端。![旧版仓库](https://github.com/Prixii/open_chat_flutter)

主要提升点在于状态管理和轮询模式的升级

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
VERSION_KEY="516^*ydj0DCZZ&EHjAEav^bw7Xt6_9MozZOIqA5RoklyJBU#q1yctzBONH&C1Ybh"
```

之后运行 `dart run build_runner build` 即可

如果你需要运行 bloc test，需要再设置 `DEVICE_ID` <del> 虽然 bloc test 在这项目里面没啥用 </del>

## 你最好需要知道的库

`flutter_bloc`、`freezed`

## `BLoC` 与 `freezed`

完整的 `BLoC` 中，需要分成 `Bloc`,`State`,`Event`三层，其中 `State` 应当是能够继承非常多个的，在不同的 `Event` 下，返回不同的 `State` 子类，但是这似乎在 `freezed` 中并不方便，于是乎 `State` 可以被看作为一个完全的 data class

<del> btw, 这样反而减轻了工作量</del>


# 贡献 / Contribute

本项目目前的贡献者如下:

<table>
  <tr>
    <td align="center"><a href="https://github.com/linyuansup"><img src="https://avatars.githubusercontent.com/u/49548096?v=4" width="100px;" alt=""/><br /><sub><b>linyuansup</b></sub></a><br />💻</a></td>
    <td align="center"><a href="https://github.com/Prixii"><img src="https://avatars.githubusercontent.com/u/87805157?s=400&u=ad791ac937be1f3b09fd13402055be13dab7338b&v=4" width="100px;" alt=""/><br /><sub><b>Prixii</b></sub></a><br />🧊</td>
