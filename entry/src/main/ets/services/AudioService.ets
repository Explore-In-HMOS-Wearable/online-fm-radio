import media from '@ohos.multimedia.media';
import StationModel from '../model/StationModel';
import { DEFAULT_STATIONS } from '../common/constants/stations';

let player: media.AudioPlayer | null = null;
let isPlaying: boolean = false;
let currentIndex: number = 0;
let stations: StationModel[] = DEFAULT_STATIONS;
let currentVolume = 0.5;

export class AudioService {
  static getCurrentStation(): StationModel {
    return stations[currentIndex];
  }

  static getVolume(): number {
    return currentVolume;
  }

  static setVolume(v: number): void {
    const clamped = Math.max(0, Math.min(1, Number(v.toFixed(2))));
    currentVolume = clamped;

    if (player) {
      player.setVolume(clamped);
    }
  }

  static async setStationById(id: number): Promise<void> {
    const index = stations.findIndex(st => st.id === id);
    if (index !== -1) {
      currentIndex = index;
      await AudioService.load(stations[currentIndex].streamUrl);
    }
  }

  static async load(url: string): Promise<void> {
    if (player) {
      player.stop();
    }

    player = media.createAudioPlayer();
    player.src = url;
    player.setVolume(currentVolume);
    player.play();
  }

  static async toggle(): Promise<void> {
    if (!player) {
      return;
    }

    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play();
      isPlaying = true;
    }
  }

  static async stop(): Promise<void> {
    if (player) {
      player.stop();
      isPlaying = false;
    }
  }

  static async next(): Promise<void> {
    if (currentIndex < stations.length - 1) {
      currentIndex++;
      await AudioService.load('https://' + stations[currentIndex].streamUrl);
      player?.play();
      isPlaying = true;
    }
  }

  static async prev(): Promise<void> {
    if (currentIndex > 0) {
      currentIndex--;
      await AudioService.load(stations[currentIndex].streamUrl);
      player?.play();
      isPlaying = true;
    }
  }

  static getPlayingState(): boolean {
    return isPlaying;
  }
}