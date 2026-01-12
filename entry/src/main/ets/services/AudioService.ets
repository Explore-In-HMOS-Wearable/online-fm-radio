import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import StationModel from '../model/StationModel';
import { DEFAULT_STATIONS } from '../common/constants/stations';

let player: media.AVPlayer | null = null;
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
    console.info(`Volume set to: ${clamped}`);
  }

  static async setStationById(id: number): Promise<void> {
    const index = stations.findIndex(st => st.id === id);
    if (index !== -1) {
      currentIndex = index;
      await AudioService.load(stations[currentIndex].streamUrl);
    }
  }

  static setCallbacks(avPlayer: media.AVPlayer): void {
    avPlayer.on('stateChange', async (state: string) => {
      console.info('AVPlayer state changed to:', state);
      switch (state) {
        case 'initialized':
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
            rendererFlags: 0
          };
          try {
            await avPlayer.prepare();
          } catch (error) {
            console.error('Failed to prepare player:', error);
          }
          break;
        case 'prepared':
          console.info('Player prepared, starting playback');
          try {
            await avPlayer.play();
            isPlaying = true;
          } catch (error) {
            console.error('Failed to play:', error);
          }
          break;
        case 'playing':
          isPlaying = true;
          console.info('Playback started');
          break;
        case 'paused':
          isPlaying = false;
          console.info('Playback paused');
          break;
        case 'stopped':
          isPlaying = false;
          console.info('Playback stopped, resetting player');
          try {
            await avPlayer.reset();
          } catch (error) {
            console.error('Failed to reset after stop:', error);
          }
          break;
        case 'completed':
          isPlaying = false;
          console.info('Playback completed');
          try {
            await avPlayer.stop();
          } catch (error) {
            console.error('Failed to stop after completion:', error);
          }
          break;
        case 'released':
          isPlaying = false;
          console.info('Player released');
          break;
        case 'error':
          isPlaying = false;
          console.error('AVPlayer entered error state');
          break;
      }
    });

    avPlayer.on('error', (err) => {
      console.error('AVPlayer error:', err.message);
      isPlaying = false;
      try {
        avPlayer.reset();
      } catch (error) {
        console.error('Failed to reset after error:', error);
      }
    });
  }

  static async load(url: string): Promise<void> {
    try {
      if (player) {
        await AudioService.stop();
        player.off('stateChange');
        player.off('error');
        await player.release();
        player = null;
      }

      player = await media.createAVPlayer();
      AudioService.setCallbacks(player);

      let streamUrl = url;
      if (!streamUrl.startsWith('http://') && !streamUrl.startsWith('https://')) {
        streamUrl = `http://${streamUrl}`;
      }

      console.info('Loading stream URL:', streamUrl);

      player.url = streamUrl;
    } catch (error) {
      console.error('Failed to load stream:', error);
      isPlaying = false;
    }
  }

  static async toggle(): Promise<void> {
    if (!player) {
      console.warn('No player instance available');
      return;
    }

    try {
      if (isPlaying) {
        await player.pause();
      } else {
        if (player.state === 'paused') {
          await player.play();
        } else {
          console.info('Player not ready yet, will auto-play when prepared');
        }
      }
    } catch (error) {
      console.error('Failed to toggle playback:', error);
    }
  }

  static async stop(): Promise<void> {
    if (player) {
      try {
        if (player.state === 'playing' || player.state === 'paused' || player.state === 'prepared') {
          await player.stop();
        } else {
          console.info(`Player in ${player.state} state, resetting instead`);
          await player.reset();
        }
        isPlaying = false;
      } catch (error) {
        console.error('Failed to stop player:', error);
        try {
          await player.reset();
        } catch (resetError) {
          console.error('Failed to reset player:', resetError);
        }
      }
    }
  }

  static async next(): Promise<void> {
    if (currentIndex < stations.length - 1) {
      currentIndex++;
      await AudioService.load(stations[currentIndex].streamUrl);
    }
  }

  static async prev(): Promise<void> {
    if (currentIndex > 0) {
      currentIndex--;
      await AudioService.load(stations[currentIndex].streamUrl);
    }
  }

  static getPlayingState(): boolean {
    return isPlaying;
  }

  static async release(): Promise<void> {
    if (player) {
      try {
        player.off('stateChange');
        player.off('error');
        await player.stop();
        await player.release();
        player = null;
        isPlaying = false;
      } catch (error) {
        console.error('Failed to release player:', error);
      }
    }
  }
}
