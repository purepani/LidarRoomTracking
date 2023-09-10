from fastestrplidar import FastestRplidar
import numpy as np
import einops as eo

from lidarbase import Lidar



class RPLidarA2(Lidar):
    def __init__(self):
        self.lidar = FastestRplidar()
        try:
            self.lidar.connectlidar()
        except:
            raise Exception

    def start(self, *args):
        self.lidar.startmotor(*args)

    def stop(self):
        self.lidar.stopmotor()

    def get_scan(self, **kwargs):
        lidar_output = np.asarray(
            self.lidar.get_scan_as_xy(**kwargs)
        )  # (num_samples, 2)
        num_samples = lidar_output.shape[0]
        z = np.zeros((num_samples,))  # (num_samples)
        points, _ = eo.pack([lidar_output, z], "samples *")
        return points


if __name__ == "__main__":
    lidar = RPLidarA2()
    lidar.start()

    try:
        while 1:
            result = lidar.get_scan()
            print(result)
    except:
        pass
    # done. Stops the motor
    lidar.stop()
