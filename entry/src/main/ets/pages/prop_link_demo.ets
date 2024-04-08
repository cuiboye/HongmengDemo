
//实体类
class Task{
  static id:number = 1
  name:string = '任务名称'+Task.id++
  finished:boolean = false
}

@Component
export struct ProgressTask{
  //总的任务数
  @State totalTasks:number = 0
  //已完成的任务数
  @State finishedTasks:number = 0
  //任务数的集合
  @State tasks:Task[] = []

  build(){
    Column(){
      Button('添加任务')
        .width(200)
        .height(35)
        .margin({bottom:20})
        .onClick(()=>{
          this.tasks.push(new Task())
        })
      TaskListItem({totalTasks:$totalTasks,finishedTasks:$finishedTasks,tasks:$tasks})
    }
  }
}

@Extend(Text) function taskSuccessed(finished: boolean) {
  .decoration({ type: finished ? TextDecorationType.LineThrough : TextDecorationType.None })
  .fontColor(finished ? Color.Blue : Color.Black)
  .fontSize(20)
}

@Component
struct TaskListItem{
  @Link totalTasks:number
  //已完成的任务数
  @Link finishedTasks:number
  //任务数的集合
  @Link tasks:Task[]

  //选中状态后的操作
  handleTaskNumber(){
    this.totalTasks = this.tasks.length
    this.finishedTasks = this.tasks.filter(item=>item.finished).length
  }

  build(){
    Column(){
      List({space:10}){
        ForEach(this.tasks,(task:Task,index)=>{
          ListItem(){
            Row(){
              Text(task.name).taskSuccessed(task.finished)
              Checkbox()
                .select(task.finished)
                .onChange(selected=>{
                  task.finished  = selected
                  this.handleTaskNumber()
                })
            }
          }
        },(item:Task)=>''+item.name)
      }
    }
  }
}
