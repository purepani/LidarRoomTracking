from abc import abstractmethod, ABC


class Lidar(ABC):
    @abstractmethod
    def get_scan(self):
        raise NotImplementedError

    @abstractmethod
    def start(self):
        raise NotImplementedError

    @abstractmethod
    def stop(self):
        raise NotImplementedError
