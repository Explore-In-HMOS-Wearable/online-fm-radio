import { router } from '@kit.ArkUI'


@Component
export default struct BackButton {
  @Prop url:string
  build() {
    Row() {
      Image($r('app.media.Chevron_Left'))
        .width(24)
        .height(24)
        .borderRadius(24)
        .backgroundColor('#343a40')
    }
    .width('100%')
    .padding({ top: 5 })
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      router.pushUrl({ url: this.url })
    })
  }
}

