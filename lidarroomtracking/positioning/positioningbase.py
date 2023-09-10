from abc import ABC, abstractmethod

class Positioning(ABC):
    
    @abstractmethod
    def move(self, position):
        raise NotImplementedError


