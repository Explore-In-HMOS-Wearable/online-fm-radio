import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State scale1: number = 1
  @State scale2: number = 1
  @State opacity1: number = 1

  aboutToAppear() {
    let scaleDirection = 1;
    let scaleStep = 0.015;

    setInterval(() => {
      if (this.scale2 < 1.3 && scaleDirection === 1) {
        this.scale2 += scaleStep;
      } else if (this.scale2 > 1 && scaleDirection === -1) {
        this.scale2 -= scaleStep;
      }

      if (this.scale2 >= 1.2) {
        scaleDirection = -1;
      } else if (this.scale2 <= 1) {
        scaleDirection = 1;
      }
    }, 20);
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center , justifyContent:FlexAlign.Center}){
      Column() {
        Text('IP Radio')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .padding(16)

        Text('♩ ♪ ♬ ♫')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .padding(16)

        Button('See Stations')
          .onClick(()=>{
            router.pushUrl({
              url:'pages/StationsListPage'
            })
          })
        .height(50)
        .backgroundColor(Color.Transparent)
        .fontSize(15)
        .scale({ x: this.scale2, y: this.scale2 });

      }
    }
    .height('100%')
    .width('100%')
    .scale({ x: this.scale1 }).opacity(this.opacity1).height('100%').width('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.START)
    PageTransitionExit({ delay: 100 })
      .slide(SlideEffect.START)
  }
}
