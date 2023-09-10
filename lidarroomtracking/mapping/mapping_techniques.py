from lidarroomtracking import lidar, positioning

from collections.abc import Iterable, Mapping
import numbers


class measure:
    def __init__(
        self,
        lidar: lidar.lidarbase.Lidar,
        positioning: positioning.positioningbase.Positioning,
    ):
        self.lidar = lidar
        self.positioning = positioning

    def stop_and_shoot_iter(self, positions):
        return stop_and_shoot(self.lidar, self.positioning, positions)


def stop_and_shoot(
    lidar: lidar.lidarbase.Lidar,
    positioning: positioning.positioningbase.Positioning,
    positions: Iterable[Mapping[int, numbers.Real]],
):
    lidar.start()
    for position in positions:
        try:
            positioning.move(position)
            yield lidar.get_scan(), position
        except KeyboardInterrupt:
            break

    lidar.stop()


if __name__ == "__main__":
    rp = lidar.rplidar.RPLidarA2()
    pos = positioning.manual.ManualPositioning()

    def position_inputs():
        while True:
            x = input("x")
            y = input("y")
            z = input("z")
            if x == "break":
                break
            yield (float(x), float(y), float(z))

    m = measure(rp, pos)
    for meas, pos in m.stop_and_shoot_iter(position_inputs):
        print(pos, meas)
