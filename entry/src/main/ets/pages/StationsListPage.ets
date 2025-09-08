import StationViewModel from '../viewmodel/StationViewModel'
import { router } from '@kit.ArkUI'
import StationModel from '../model/StationModel'
import BackButton from '../common/components/BackButton'

@Entry
@Component
struct StationListPage {
  @State stationVM: StationViewModel = new StationViewModel()
  @State scale1: number = 1
  @State opacity1: number = 1
  private scroller: Scroller = new Scroller()
  build() {
    Column(){
      BackButton({url: 'pages/Index'})
    Row() {
      Scroll(this.scroller) {
        Column() {
          Text('Stations')
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .padding(12)

          List({ space: 10 }) {
            ForEach(this.stationVM.getAllStations(), (station: StationModel, index: number) => {
              ListItem() {
                Row({ space: 12 }) {
                  Text(station.name)
                    .fontSize(18)
                  Image($r('app.media.play'))
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/PlayerPage',
                        params: { stationId: station.id }
                      })
                    })
                    .height(24)
                    .width(24)
                }
                .padding(12)
                .border({ width: 1, color: '#cccccc' })
                .borderRadius(8)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
              }.onClick(() => {
                router.pushUrl({
                  url: 'pages/PlayerPage',
                  params: { stationId: station.id }
                })
              })
            })
          }
          .width('100%')
          .edgeEffect(EdgeEffect.None)
        }
        .width('100%')
        .padding(12)
      }
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto }) {
        Text()
          .width(20)
          .height(100)
          .borderRadius(10)
          .backgroundColor('#C0C0C0')
      }
      .width(20)
      .backgroundColor('#ededed')
    }
    .width('100%')
    .height('100%')
  }.scale({ x: this.scale1 }).opacity(this.opacity1).height('100%').width('100%').justifyContent(FlexAlign.Center)
  }
  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.END) //Right
    PageTransitionExit({ delay:100 })
      .slide(SlideEffect.END) //Right
  }
}
