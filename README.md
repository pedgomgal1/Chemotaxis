<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

  <h1>Chemotaxis analysis for <em>Drosophila</em> Larvae</h1>

  This repository contains code for analyzing navigation-related parameters in <em>Drosophila</em> larvae, specifically focusing on measuring speed, acceleration, navigation index, and classifying behaviors such as run, stop, turn, cast, among others.</p>

  <h2>Introduction</h2>

  <p><em>Drosophila</em> larvae exhibit chemotactic behaviors, navigating in response to chemical stimuli. This repository provides tools to analyze the movement patterns of larvae in the presence and absence of an odorant, ethyl acetate, to understand their chemotactic responses.</p>

  <h2>Experimental Setup</h2>

  <p>In odorant experiments, four odor patches are strategically placed on the left side of an agar plate (20x20 cm). Larvae are initially placed approximately in the center of the agar plates. The movement of larvae is recorded over time, capturing their responses to the odorant cues.</p>

  <h2>Features</h2>

  <ul>
    <li><strong>Speed Analysis:</strong> Calculate the speed of larval movement over time.</li>
    <li><strong>Acceleration Measurement:</strong> Determine the acceleration profile of larvae during navigation.</li>
    <li><strong>Navigation Index:</strong> Quantify the directionality and efficiency of larval movement towards or away from the odor source.</li>
    <li><strong>Behavior Classification:</strong> Classify larval behaviors such as run, stop, turn, cast, etc., based on movement patterns.</li>
  </ul>

  <h2>Usage</h2>

  <ol>
    <li><strong>Data Collection:</strong> Record larval movement videos in the presence and absence of ethyl acetate odorant.</li>
    <li><strong>Data Preprocessing:</strong> Prepare the recorded videos for analysis, ensuring proper frame rate and resolution.</li>
    <li><strong>Code Execution:</strong> Run the provided scripts to analyze the movement parameters and behaviors.</li>
    <li><strong>Data Visualization:</strong> Visualize the results using built-in visualization tools or export data for custom analysis.</li>
  </ol>

  <h2>Getting Started</h2>

  <p>To get started with using this repository, follow these steps:</p>

  <ol>
    <li>Clone this repository to your local machine.</li>
    <li>Install the required dependencies (listed in <code>requirements.txt</code>).</li>
    <li>Refer to the provided documentation for detailed instructions on data preparation and analysis.</li>
    <li>Run the provided example scripts to understand the workflow and customize for your experiments.</li>
  </ol>

  <h2>Examples</h2>

  <img src="example_images/example1.png" alt="Example Image 1">
  <p><em>Figure 1: Trajectory of <em>Drosophila</em> larva in the presence of ethyl acetate odorant.</em></p>

  <img src="example_images/example2.png" alt="Example Image 2">
  <p><em>Figure 2: Trajectory of <em>Drosophila</em> larva without any odour stimulus.</em></p>

  <h2>Contributing</h2>

  <p>Contributions to this repository are welcome! If you have suggestions for improvement, new features to add, or bug fixes, please open an issue or submit a pull request.</p>

  <h2>License</h2>

  <p>This project is licensed under the <a href="LICENSE">MIT License</a>.</p>

  <h2>Acknowledgments</h2>

  <p> This work was depeloved at the MRC LMB in Cambridge (UK) under the supervision and guidance of A.Cardona and M.Zlatic groups.</p>

  <h2>Contact</h2>

  <p><a href="mailto:pgomez-ibis@us.es">pgomez-ibis@us.es</a>.</p>

</body>
</html>
