@Component
export struct StatCard {
  @Prop title: string = '';
  @Prop value: string = '';

  build() {
    Column({ space: 4 }) {
      Text(this.title)
        .fontSize(10)
        .fontColor('#C9CED6')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F5F7FA')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor('#1A2233')
    .borderRadius(12)
  }
}
