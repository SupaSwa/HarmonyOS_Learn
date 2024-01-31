class Task {
  static id : number = 1
  //任务名称
  name : string = `任务${Task.id++}`
  //任务状态
  finished : boolean = false
}
//统一卡片样式定义
@Styles function card(){
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
}
//任务完成样式
@Extend(Text) function finishedTask(){
    .decoration({type:TextDecorationType.LineThrough})
    .fontColor('#B1B2B1')
}

@Entry
@Component
struct Index {
  //总任务数量
  @State totalTask: number = 0
  //已完成任务数量
  @State finishTask: number = 0
  //任务数据存储
  @State tasks : Task[] = []

  handleTaskChange(){
    this.totalTask = this.tasks.length //更新任务总数量
    // 更新已完成任务的数量
    this.finishTask = this.tasks.filter(item => item.finished).length
  }

  build() {
    Column(){
      // 1.任务进度卡片
      Row(){
        Text('任务进度：')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Stack(){
          Progress({
            value: this.finishTask,
            total: this.totalTask,
            type: ProgressType.Ring
          })
          .width(100)
          Row(){
            Text(this.finishTask.toString())
              .fontSize(24)
              .fontColor('#36D')
            Text('/' + this.totalTask.toString())
              .fontSize(24)
          }
        }
      }
      .card()
      .margin({top:20,bottom:10})
      .justifyContent(FlexAlign.SpaceEvenly)
      // 2.新增任务按钮
      Button('新增任务')
        .width('60%')
        .onClick(()=>{
          this.tasks.push(new Task()) //新增一个任务
          this.handleTaskChange()
        })
      // 3.任务列表
      List({space : 10}){
        ForEach(this.tasks,(item : Task , index)=>{
          ListItem(){
            Row(){
              Text(item.name)
                .fontSize(24)
              Checkbox()
                .select(item.finished)
                .onChange(val =>{
                  // 更新当前任务的状态
                  item.finished = val
                  this.handleTaskChange()
                })
            }
            .card()
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .swipeAction({end : this.DeletButton(index)})
        })
      }
      .width('100%')
      .layoutWeight(1)//将界面剩余的高度全部赋予LIST
      .alignListItem(ListItemAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')
  }

  //列表删除设置LIST
  @Builder DeletButton(index : number){
    Button(){
      Text('删除')
        // .fontSize()
        .fontWeight(FontWeight.Bold)
    }
    .width('40').height('40')
    .backgroundColor(Color.Red)
    .borderRadius(10)
    .type(ButtonType.Normal)
    .margin({left:10})
    .onClick(()=>{
      this.tasks.splice(index , 1)//删除数组中元素，1个
      this.handleTaskChange()
    })
  }
}