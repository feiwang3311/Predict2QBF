# to generate random QBF instances
python3 randQBF.py --n_quantifiers 2 -a 3 -a 3 -a 8 -a 8 --n_clauses 50 --n_problems 10 --target_dir 3_3_8_8_50_10

# to generate paired random QBF instances (differ by one lit in formula, but differ completely in sat/unsat)
python3 randQBFinc.py --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3 --n_clauses 10 --n_pairs 10 --target_dir 2_3_2_3_10_10 
python3 randQBFinc.py --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --n_clauses 95 --n_pairs 400 --target_dir 2_3_8_10_80_400

# to transform dimacs to pickle dump (need to find optimal max_node_per_batch to maximize the efficiency of GPU memory)
python3 dimacs_to_data.py  --dimacs_dir /homes/wang603/QBF/train10 --out_dir ./train10/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10

# to transform dimacs to pickle dump for train2_unsat and test2_unsat, predict forall vars
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train2_unsat --out_dir ./train2_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/test2_unsat --out_dir ./test2_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3
# to transform dimacs to pickle dump for train10_unsat and test10_unsat, predict forall vars
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/test10_unsat --out_dir ./test10_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10
# find out optimal size of batch (40000 is probably the best)
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat1000_40000/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat1000_20000/ --max_nodes_per_batch 20000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10
# generate smaller data set (10 problems only)
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat10/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 10
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat20/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 20
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat40/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 40
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat80/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 80
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat160/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 160
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat320/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 320
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat640/ --max_nodes_per_batch 40000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --max_dimacs 640

# to train
python3 train.py --train_dir ./train10/ --run_id 0 
# to train on train2_unsat
python3 train.py --train_dir ./train2_unsat/ --run_id 1
# to test on test2_unsat
python3 test.py --test_dir ./test2_unsat/ --restore_id 1 --restore_epoch 333 --n_rounds 16 

# to train on train10_unsat
python3 train.py --train_dir ./train10_unsat/ --run_id 2
# to test on test10_unsat
python3 test.py --test_dir ./test10_unsat/ --restore_id 2 --restore_epoch 480 --n_rounds 16

# to train after getting better architecture
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat/ --run_id 3 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat/ --run_id 4 --model_id 1
CUDA_VISIBLE_DEVICES=2 python3 train.py --train_dir ./train10_size/ --run_id 1000 --model_id 0
CUDA_VISIBLE_DEVICES=3 python3 train.py --train_dir ./train10_size2/ --run_id 1000 --model_id 0
CUDA_VISIBLE_DEVICES=3 python3 train.py --train_dir ./train10_size8/ --run_id 1000 --model_id 0

CUDA_VISIBLE_DEVICES=2 python3 train.py --train_dir ./train10_unsat1000_40000/ --run_id 3 --restore_id 3 --restore_epoch 5999 --model_id 0
CUDA_VISIBLE_DEVICES=3 python3 train.py --train_dir ./train10_unsat1000_20000/ --run_id 4 --restore_id 4 --restore_epoch 5999 --model_id 1

# curriculum training
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat20/ --run_id 52 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat20/ --run_id 53 --model_id 1
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat40/ --run_id 54 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat40/ --run_id 55 --model_id 0 --restore_id 52 --restore_epoch 494
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat80/ --run_id 56 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat80/ --run_id 57 --model_id 0 --restore_id 54 --restore_epoch 763
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat160/ --run_id 58 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat160/ --run_id 59 --model_id 0 --restore_id 56 --restore_epoch 1030
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat320/ --run_id 60 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat320/ --run_id 61 --model_id 0 --restore_id 58 --restore_epoch 1865
CUDA_VISIBLE_DEVICES=0 python3 train.py --train_dir ./train10_unsat640/ --run_id 62 --model_id 0
CUDA_VISIBLE_DEVICES=1 python3 train.py --train_dir ./train10_unsat640/ --run_id 63 --model_id 0 --restore_id 60 --restore_epoch 2669
