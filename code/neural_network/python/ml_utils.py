"""Miscellaneous utilities for machine learning applications."""
from enum import Enum
from typing import Union, List
import math
import random

class ActFunc(Enum):
    """Activation functions for layers in neural networks.
    
    :param RELU: Rectified Linear Unit (ReLU).
    :param TANH: Hyperbolic tangent (tanh).
    """
    RELU = 0 
    TANH = 1 

    def __str__(self):
        """Provide the ActFunc enumerator as text.
        
        :return: The ActFunc enumerator as a string.
        """
        return self.name

class Math:
    """Class holding static methods for mathematical operations"""

    @staticmethod
    def relu(number: float) -> float:
        """Get the Rectified Linear Unit (ReLU) activation for a given input.
        
        :param number: The number for which to calculate the Relu.

        :return: The ReLU activation as a double.
        """
        return number if number > 0.0 else 0.0
    
    @staticmethod
    def relu_gradient(number: float) -> float:
        """Get the gradient of the Rectified Linear Unit (ReLU) function for a given input.
        
        :param number: The number for which to calculate the ReLU gradient.

        :return: The ReLU gradient as a double.
        """
        return 1.0 if number > 0.0 else 0.0
    
    @staticmethod
    def tanh(number: float) -> float:
        """Get the hyperbolic tangent (tanh) for a given input.

        :param number: The number for which to calculate the hyperbolic tangent.

        :return: The hyperbolic tangent as a double.
        """
        return math.tanh(number)
    
    @staticmethod
    def tanh_gradient(number: float) -> float:
        """Get the gradient of the hyperbolic tangent (tanh) for a given input.

        :param number: The number for which to calculate the gradient of the hyperbolic tangent.

        :return: The gradient of the hyperbolic tangent as a double.
        """
        return 1.0 - pow(math.tanh(number), 2)
    
    @staticmethod
    def act_func_output(number: float, act_func: ActFunc) -> float:
        """Get the activation function output for a given input.
        
        :param number: The number for which to calculate the activation function output.
        :param act_func: The activation function used.

        :return: The activation function output as a double.
        """
        return Math.relu(number) if act_func == ActFunc.RELU else Math.tanh(number)
    
    @staticmethod
    def act_func_gradient(number: float, act_func: ActFunc) -> float:
        """Get the activation function gradient for a given input.
        
        :param number: The number for which to calculate the activation function gradient.
        :param act_func: The activation function used.

        :return: The activation function gradient as a double.
        """
        return Math.relu_gradient(number) if act_func == ActFunc.RELU else Math.tanh_gradient(number)

class Random:
    """Class holding static methods for generating random numbers"""

    @staticmethod
    def number(min:  Union[int, float] = 0, max:  Union[int, float] = 100) ->  Union[int, float]:
        """Get a random number in specified range.
        
        :param min: The minimum number of specified range (default = 0).
        :param max: The maximum number of specified range (default = 100).

        :return: Random number in specified range [min, max].
        """
        if min > max:
            raise ValueError("Cannot generate random number when min is more than max!")
        return random.uniform(min, max) if isinstance(min, float) or isinstance(max, float) else random.randint(min, max)

    @staticmethod
    def list(size: int, min: Union[int, float] = 0, max: Union[int, float]= 100) -> list[Union[int, float]]:
        """Get new one-dimensional list holding random numbers in specified range.
        
        :param size: The size of the new list.
        :param min: The minimum number of specified range (default = 0).
        :param max: The maximum number of specified range (default = 100).

        :return: List holding random numbers in specified range [min, max].
        """
        return [Random.number(min, max) for _ in range(size)]
    
    @staticmethod
    def list_2d(row_count: int, column_count: int, min: Union[int, float] = 0, 
                max: Union[int, float] = 100) -> List[List[Union[int, float]]]:
        """Get new two-dimensional list holding random numbers in specified range.
        
        :param row_count: The row of columns of the new list.
        :param column_count: The number of columns of the new list.
        :param min: The minimum number of specified range (default = 0).
        :param max: The maximum number of specified range (default = 100).

        :return: List holding random numbers in specified range [min, max].
        """
        return [Random.list(column_count, min, max) for _ in range(row_count)]
    
    @staticmethod
    def shuffle_list(lst: List[Union[int, float]]) -> None:
        """Shuffle the content of a list.
        
        :param list: The list to shuffle.
        """
        random.shuffle(lst)
