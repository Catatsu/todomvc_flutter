# todomvc

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## API

Todoリストの取得と追加
https://morning-ocean-78789.herokuapp.com/tasks
get
post

Todo１件に対する操作
https://morning-ocean-78789.herokuapp.com/tasks/{taskid}
get 取得
put 更新
delete 削除

<GETの例>
curl https://morning-ocean-78789.herokuapp.com/tasks

<POSTの例>
curl -H 'Content-Type:application/json' -d '{"name":"Test"}' https://morning-ocean-78789.herokuapp.com/tasks

<データ構造>
    name: {
        type: String,
        required: 'Kindly enter the name of the task'
    },
    description: {
        type: String,
        default: ['']
    },
    Created_date: {
        type: Date,
        default: Date.now
    },
    status: {
        type: [{
            type: String,
            enum: ['pending', 'ongoing', 'completed']
        }],
        default: ['pending']
    }