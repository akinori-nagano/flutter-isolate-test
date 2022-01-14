# flutter-isolate-test

## build web

``` bash
$ sh ./build-src.sh ; flutter build web
```

## run web

``` bash
$ sh ./runserv.sh
```

## その他

sound-null-saftyでエラーが出た時に、以下のコマンドでpackageを更新してくれる

``` bash
$ flutter pub outdated --mode=null-safety
$ flutter pub upgrade --null-safety
```
