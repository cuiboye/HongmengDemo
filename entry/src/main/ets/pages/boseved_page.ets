//
// class Task {
//   static  id: number = 1
//   name:string = '任务名称'+Task.id++
//   finished:boolean = false
// }
//
// @Styles function  card() {
//   .width('90%')
//   .padding(20)
//   .backgroundColor(Color.White)
//   .borderRadius(15)
//   .shadow({radius:6,color:'#1F00000',offsetX:2,offsetY:4})
// }
//
// @Extend(Text) function tasksuccessed(finish: boolean) {
//   .decoration({type: finish ? TextDecorationType.LineThrough : TextDecorationType.None})
//   .fontColor(finish? '#B1B2B1': Color.Black)
// }
//
//
// @Component
// export  struct  ProgressTask {
//   @State totalTasks: number = 0
//   @State finishTasks:number = 0
//   @State tasks: Task[] = []
//
//   build() {
//     Column() {
//       //顶部任务进度卡片
//       TaskStitics({ totalTasks: this.totalTasks, finishTasks: this.finishTasks })
//       //任务列表+新增按钮
//       StaticList({totalTasks:$totalTasks,finishTasks:$finishTasks,tasks:$tasks})
//     }
//   }
// }
//
//
// @Component
// struct TaskStitics {
//
//   @Prop totalTasks: number
//   @Prop finishTasks:number
//
//   build() {
//     //进度卡片
//     Row() {
//       Text('任务进度:')
//         .fontWeight(FontWeight.Bold)
//         .fontSize(30)
//         .layoutWeight(1)
//
//       Stack() {
//         Progress({value:this.finishTasks,total:this.totalTasks,type:ProgressType.Ring})
//           .width(100)
//
//         Row() {
//           Text(this.finishTasks.toString())
//             .fontSize(24)
//             .fontColor('#36D')
//
//           Text(' / '+this.totalTasks.toString())
//             .fontSize(24)
//         }
//       }
//
//     }
//     .card()
//     .height(150)
//     .margin({top:20,bottom:10})
//     .justifyContent(FlexAlign.SpaceEvenly)
//   }
// }
//
// @Component
// struct StaticList {
//
//   @Link totalTasks: number
//   @Link finishTasks:number
//   @Link tasks: Task[]
//
//   handleTaskNumber() {
//     this.totalTasks = this.tasks.length
//     this.finishTasks = this.tasks.filter(item => item.finished).length
//     console.log('完成任务数' + this.finishTasks)
//   }
//
//   @Builder deleteButton(index:number) {
//     Button('➖')
//       .fontColor(Color.White)
//       .backgroundColor(Color.Red)
//       .width(40)
//       .height(40)
//       .type(ButtonType.Circle)
//       .margin({left:5})
//       .onClick(() => {
//         this.tasks.splice(index,1)
//         this.handleTaskNumber()
//       })
//   }
//
//   build() {
//     Column() {
//       //添加按钮
//       Button('新增任务')
//         .width(200)
//         .height(35)
//         .onClick(() => {
//           this.tasks.push(new Task())
//           this.handleTaskNumber()
//         })
//         .margin({ bottom: 20 })
//
//       //任务列表
//       List({ space: 10 }) {
//         ForEach(this.tasks, (task: Task, index) => {
//           ListItem() {
//             Row() {
//               Text(task.name)
//                 .fontSize(20)
//                 .tasksuccessed(task.finished)
//
//               Checkbox()
//                 .select(task.finished)
//                 .onChange(value => {
//                   task.finished = value
//                   console.log('任务状态' + value + '')
//                   this.handleTaskNumber()
//                 })
//             }
//             .card()
//             .justifyContent(FlexAlign.SpaceBetween)
//           }
//           .swipeAction({ end: this.deleteButton(index) })
//         }, item => '' + item.name)
//       }
//       .width('100%')
//       .alignListItem(ListItemAlign.Center)
//       .layoutWeight(1)
//     }
//     .width('100%')
//     .height('100%')
//   }
//
// }
