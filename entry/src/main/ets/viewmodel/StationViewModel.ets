import StationModel from '../model/StationModel'
import { DEFAULT_STATIONS } from '../common/constants/stations'

export default class StationViewModel {
  stations: StationModel[] = [];

  constructor() {
    this.loadStations();
  }

  loadStations() {
    this.stations = DEFAULT_STATIONS;
  }

  getAllStations(): StationModel[] {
    return this.stations;
  }

  getStationById(id: number): StationModel | undefined {
    return this.stations.find(station => station.id === id);
  }
}
