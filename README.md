<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

  <h1>Chemotaxis analysis for <em>Drosophila</em> Larvae</h1>

  This repository contains Matlab and Python [in progress] code for analysing navigation-related parameters in <em>Drosophila</em> larvae, specifically focusing on measuring navigation index, larvae orientation, speed, acceleration, and classifying behavioural events such as run, stop, turn, cast, among others.</p>

  <h2>Introduction</h2>

  <p><em>Drosophila</em> larvae exhibit chemotactic behaviours, navigating in response to chemical stimuli. This repository provides tools to extract and analyse movement patterns of larvae in the presence and absence of an odorant (e.g. ethyl acetate as attractive odour). Our goal is to compare in an objective way, how mutant <em>Drosophila</em> larvae (e.g. Parkinson's disease larva models, or other neurodegenerative models), have impaired their behavioural natural responses in navigation and chemotaxis, by evaluating their motor and decision making abilities. The experimental procedure was designed as follows:
    1. WT and mutant <em>Drosophila</em> larvae are synchronised and rinsed in equal conditions, same food, same humidity, same age, same incubator and light/darkness periods.
    2. Groups of 30-45 larvae per genotype are gently separated from food and cleaned with water in synchronised timepoint. We worked with ~48h old larvae, i.e. late L1 - early L2 instar larva. 
    3. Straight away, we place the larvae in the center of an square arena (20x20 cm^2). This arena is basically a plastic-made plate filled with 3% agar. This plate, is covered with a transparent lid where at the left side we place 4 equidistant odour patches (same size, same odour concentration).
    4. This arena is placed in a behavioural rig, in controlled conditions of temperature, humidity and light (complete darkness), composed by a high-quality camera and IR-light illumination (invisible for larvae).
    5. Inmediately, We start the larvae tracking by using the software MultiWormTracker (MWT, https://github.com/ZlaticLab/MWT).
    6. MWT outputs are processed through Choreography software, giving us as output a set of files: X and Y coordinates of the larvae center of mass, speed, curvature, outlines, spine, etc.
    7. These files are taken as input for our software, and analysed, giving as output a set of motor and navigation properties. Always analysing the larvae behaviour in a sense of group because individual larva tracking is very challenging and usually resulting in misinterpretation of the results because of tracking failures.
  
  </p>

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
