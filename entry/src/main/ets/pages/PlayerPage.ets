import StationModel from '../model/StationModel'
import StationViewModel from '../viewmodel/StationViewModel'
import { router } from '@kit.ArkUI'
import BackButton from '../common/components/BackButton'
import { ActionIcon } from '../common/components/ActionIcon'
import { AudioService } from '../services/AudioService'
import { media } from '@kit.MediaKit'
import { BusinessError } from '@kit.BasicServicesKit'


let avPlayer: media.AVPlayer;
media.createAVPlayer((error: BusinessError, video: media.AVPlayer) => {
  if (video != null) {
    avPlayer = video;
    console.info('Succeeded in creating AVPlayer');
  } else {
    console.error(`Failed to create AVPlayer, error message:${error.message}`);
  }
});

@Entry
@Component
struct PlayerPage {
  private stationVM: StationViewModel = new StationViewModel()
  @State station: StationModel = new StationModel(0, '', '')
  @State isPlaying: boolean = false
  @State volume: number = 0;

  async aboutToAppear() {
    avPlayer.setVolume(this.volume);
    let stationIdSTR:string='stationId'
    let params: object = router.getParams()
    const stationId = Number(params[stationIdSTR])
    let foundStation = this.stationVM.getStationById(stationId)
    if (foundStation) {
      this.station = foundStation
      await AudioService.setStationById(stationId)
      this.isPlaying = AudioService.getPlayingState()
    }
  }

  async togglePlay() {
    await AudioService.toggle()
    this.isPlaying = AudioService.getPlayingState()
  }

  async playNext() {
    await AudioService.next()
    this.station = AudioService.getCurrentStation()
    this.isPlaying = AudioService.getPlayingState()
  }

  async playPrev() {
    await AudioService.prev()
    this.station = AudioService.getCurrentStation()
    this.isPlaying = AudioService.getPlayingState()
  }

  async increaseVol() {
    const STEP = 0.1;
    const next = Math.min(1.0, Number((this.volume + STEP).toFixed(2)));
    AudioService.setVolume(next);
    this.volume = next;
  }

  async decreaseVol() {
    const STEP = 0.1;
    const next = Math.max(0.0, Number((this.volume - STEP).toFixed(2)));
    AudioService.setVolume(next);
    this.volume = next;
  }

  build() {
    Column() {
      BackButton({ url: 'pages/StationsListPage' })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Text(this.station.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .padding(10)

        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
            ActionIcon({ icon: $r('app.media.rewind') }).onClick(() => this.playPrev())
            ActionIcon({ icon: this.isPlaying ? $r('app.media.paues') : $r('app.media.play') }).onClick(() => this.togglePlay())
            ActionIcon({ icon: $r('app.media.rewind') }).rotate({ angle: 180 }).onClick(() => this.playNext())
          }
          .width('80%')
          .margin({ bottom: 30, top: 40 })

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
            ActionIcon({ icon: $r('app.media.volume_minus') }).onClick(()=>{
              this.decreaseVol()
            })
            ActionIcon({ icon: $r('app.media.volume_plus') }).onClick(()=>{
              this.increaseVol()
            })
          }
          .width('80%')
        }
      }
      .padding({ top: 10 })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .height('100%')
    .width('100%')
  }
}
