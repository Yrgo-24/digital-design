"""Implementation of dense layers for neural networks"""
from __future__ import annotations
from ml_utils import ActFunc, Math, Random

class DenseLayer:
    """Class implementation of dense layers."""

    def __init__(self, node_count: int, weight_count: int, act_func: ActFunc = ActFunc.RELU) -> None:
        """Create new dense layer.
        
        :param node_count: The number of nodes in the new layer.
        :param weight_count: The number of weights per node in the new layer.
        :param act_func: The activation function of the layer (default = ReLU).
        """
        self._output   = Random.list(node_count, 0.0, 0.0)
        self._error    = Random.list(node_count, 0.0, 0.0)
        self._bias     = Random.list(node_count, 0.0, 1.0)
        self._weights  = Random.list_2d(node_count, weight_count, 0.0, 1.0)
        self._act_func = act_func
    
    def output(self) -> tuple[float]:
        """Get the output of the dense layer.
        
        :return: Tuple holding the output of the dense layer.
        """
        return tuple(self._output)

    def error(self) -> tuple[float]:
        """Get the error of the dense layer.
        
        :return: Tuple holding the error of the dense layer.
        """
        return tuple(self._error)
    
    def bias(self) -> tuple[float]:
        """Get the bias of the dense layer.
        
        :return: Tuple holding the bias of the dense layer.
        """
        return tuple(self._bias)
    
    def weights(self) -> tuple[tuple[float]]:
        """Get the weights of the dense layer.
        
        :return: Two-dimensional tuple holding the weights of the dense layer.
        """
        return tuple(map(tuple, self._weights))
    
    def act_func(self) -> ActFunc:
        """Get the activation function of the dense layer.
        
        :return: The activation function as an enumerator of enum ActFunc.
        """
        return self._act_func
    
    def node_count(self) -> int:
        """Get the number of nodes in the dense layer.
        
        :return: The number of nodes as an integer.
        """
        return len(self._output)
    
    def weight_count(self) -> int:
        """Get the number of weights per node in the dense layer.
        
        :return: The number of weights per node as an integer.
        """
        return len(self._weights[0]) if len(self._weights) > 0 else 0
    
    def feedforward(self, input: list[float]) -> None:
        """Perform feedforward for dense layer.
        
        :param input: List holding the input of the dense layer.
        """
        if len(input) != self.weight_count():
            raise ValueError(f"Feedforward input size {len(input)} \
                             does not match the weight count {self.weight_count()}!")
        for i in range(self.node_count()):
            weighted_sum = self._bias[i]
            for j in range(self.weight_count()):
                weighted_sum += self._weights[i][j] * input[j]
            self._output[i]  = Math.act_func_output(weighted_sum, self._act_func)

    def backpropagate_output(self, reference: list[float]) -> None:
        """Perform backpropagation for output layer.

        :param reference: List holding reference values.

        Note:
            This method is implemented for output layers only.
        """
        if len(reference) != self.node_count():
            raise ValueError(f"Backpropagation reference size {len(reference)} \
                             does not match the node count {self.node_count()}!")
        for i in range(self.node_count()):
            error          = reference[i] - self._output[i]
            self._error[i] = error * Math.act_func_gradient(self._output[i], self._act_func)

    def backpropagate_hidden(self, next_layer: DenseLayer) -> None:
        """Perform backpropagation for hidden layer.

        :param next_layer: The next layer in the neural network.
        
        Note:
            This method is implemented for hidden layers only.
        """
        if next_layer.weight_count() != self.node_count():
            raise ValueError(f"The next layer shape [{next_layer.node_count, next_layer.weight_count()}], \
                             does not match the current layer shape [{self.node_count, self.weight_count()}]!")
        for i in range(self.node_count()):
            error = 0.0
            for j in range(next_layer.node_count()):
                error      += next_layer.error()[j] * next_layer.weights()[j][i]
            self._error[i] = error * Math.act_func_gradient(self._output[i], self._act_func)

    def optimize(self, input: list[float], learning_rate: float = 0.01) -> None:
        """Perform optimization for dense layer.

        :param input: List holding the input of the layer.
        :param learning_rate: The rate with which to optimize the parameters.
        """
        if len(input) != self.weight_count():
            raise ValueError(f"Optimization input size {len(input)} \
                             does not match the weight count {self.weight_count()}!")
        if learning_rate <= 0:
            raise ValueError(f"Invalid learning rate {learning_rate}!")
        for i in range(self.node_count()):
            self._bias[i] += self._error[i] * learning_rate
            for j in range(self.weight_count()):
                self._weights[i][j] += self._error[i] * learning_rate * input[j]

    def print(self) -> None:
        """Print stored parameters with one decimal precision."""
        formatted_list    = lambda lst: ", ".join([f"{number:.1f}" for number in lst])
        formatted_list_2d = lambda lst: "], [".join([formatted_list(row) for row in lst])
        print(f"--------------------------------------------------------------------------------")
        print(f"Output:\t\t\t[{formatted_list(self._output)}]")
        print(f"Error:\t\t\t[{formatted_list(self._error)}]")
        print(f"Bias:\t\t\t[{formatted_list(self._bias)}]")
        print(f"Weights:\t\t[[{formatted_list_2d(self._weights)}]]")
        print(f"Activation function:\t{self._act_func}")
        print(f"--------------------------------------------------------------------------------\n")
