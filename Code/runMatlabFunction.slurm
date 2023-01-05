#!/bin/bash
# --------------------------------------------------------------
### PART 1: Requests resources to run your job.
# --------------------------------------------------------------
### Optional. Set the job name
#SBATCH --job-name=trackTrajectories
### Optional. Set the output filename.
### SLURM reads %x as the job name and %j as the job ID
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
### REQUIRED. Specify the PI group for this job
#SBATCH --account=cardonaGroup
### Optional. Request email when job begins and ends
### Specify high priority jobs
#SBATCH --qos=user_qos_manager
# SBATCH --mail-type=ALL
### Optional. Specify email address to use for notification
#SBATCH --mail-user=pgg@mrc-lmb.cam.ac.uk
### REQUIRED. Set the partition for your job.
#SBATCH --partition=cpu
### REQUIRED. Set the number of cores that will be used for this job.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
### REQUIRED. Set the memory required for this job.
#SBATCH --mem=256G
### REQUIRED. Specify the time required for this job, hhh:mm:ss
#SBATCH --time=12:00:00
# --------------------------------------------------------------
### PART 2: Executes bash commands to run your job
# --------------------------------------------------------------
### SLURM Inherits your environment. cd $SLURM_SUBMIT_DIR not needed
pwd; hostname; date
echo "CPUs per task: $SLURM_CPUS_PER_TASK"
### Load required modules/libraries if needed
module load matlab/r2020b
### This was recommended by MATLAb through technical support
ulimit -u 63536 
cd $PWD
matlab -nodisplay -nosplash -softwareopengl < /PATH/trackAndplotTrajectories_parallel.m > /PATH/out_message.txt
date
~