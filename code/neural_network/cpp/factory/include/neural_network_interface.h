/**
 * @brief Definition of interface for neural networks.
 */
#pragma once

#include <iostream>
#include <vector>

namespace ml
{

/**
 * @brief Interface for dense layers in neural networks.
 */
class NeuralNetworkInterface
{
public:

    /**
     * @brief Delete neural network.
     */
    NeuralNetworkInterface() = default;
    
    /**
     * @brief Get the number of inputs in the neural network.
     *  
     * @return The number of inputs as an integer.
     */
    virtual std::size_t inputCount() const = 0;

    /**
     * @brief Get the number of outputs in the neural network.
     * 
     * @return The number of outputs as an integer.
     */
    virtual std::size_t outputCount() const = 0;

    /**
     * @brief Get the output of the neural network.
     * 
     * @return Reference to vector holding the output of the network.
     */
    virtual const std::vector<double>& output() const = 0;

    /**
     * @brief Perform prediction based on given input.
     * 
     * @param input Reference to vector holding the input on which to predict.
     * 
     * @return Reference to vector holding the predicted output.
     */
    virtual const std::vector<double>& predict(const std::vector<double>& input) = 0;

    /**
     * @brief Add sets of training data. 
     *
     * @param trainingInput  Reference to vector holding values of the input sets.
     * @param trainingOutput Reference to vector holding values of the output sets.
     */
    virtual void addTrainingSets(const std::vector<std::vector<double>>& trainingInput,
                                 const std::vector<std::vector<double>>& trainingOutput) = 0;

    /**
     * @brief Train the neural network.
     *
     * @param epochCount   The number of epochs to perform training.
     * @param learningRate The rate with witch to optimize the network parameters 
     *                     (default = 0.01).
     *
     * @return The accuracy post training as a double in the range 0 - 1, which
     *         corresponds to 0 - 100 %.
     */
    virtual double train(const std::size_t epochCount, const double learningRate = 0.01) = 0;

    /**
     * @brief Get the accuracy of the network by using stored training data.
     * 
     * @return The accuracy as a double in the range 0 - 1, which corresponds 
     *          to 0 - 100 %.
     */
    virtual double accuracy() = 0;

    /**
     * @brief Print training results.
     * 
     * @param ostream      Reference to output stream (default = terminal print).
     * @param decimalCount The number of decimals for which to print floats
     *                     (default = 1).
     */
    virtual void printResults(std::ostream& ostream = std::cout, 
                              const std::size_t decimalCount = 1U) = 0;
};

} // namespace ml