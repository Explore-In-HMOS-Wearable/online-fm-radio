export default class StationModel {
  id: number;
  name: string;
  streamUrl: string;

  constructor(id: number, name: string, streamUrl: string) {
    this.id = id;
    this.name = name;
    this.streamUrl = streamUrl;
  }
}
