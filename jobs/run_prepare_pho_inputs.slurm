#!/bin/bash
#SBATCH --partition=IllinoisComputes-GPU
#SBATCH --account=jimeng-ic
#SBATCH --job-name=prepare_pho_inputs
#SBATCH --time=04:00:00
#SBATCH --mem=16G
#SBATCH --gres=gpu:H200:1
#SBATCH --cpus-per-task=4
#SBATCH --output=/u/zelalae2/scratch/jobs/logs/prepare_pho_inputs_output.log
#SBATCH --error=/u/zelalae2/scratch/jobs/logs/prepare_pho_inputs_error.log



module load cuda/12.6
source ~/scratch/PyHealth/venv_pyhealth/bin/activate
cd ~/scratch/PyHealth/examples
echo "Starting Preparing PHO Inputs ..."
python prepare_rdma_inputs.py phenotype
echo "Preparing PHO Inputs completed."