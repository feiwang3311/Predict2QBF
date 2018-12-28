# to generate random QBF instances
python3 randQBF.py --n_quantifiers 2 -a 3 -a 3 -a 8 -a 8 --n_clauses 50 --n_problems 10 --target_dir 3_3_8_8_50_10

# to generate paired random QBF instances (differ by one lit in formula, but differ completely in sat/unsat)
python3 randQBFinc.py --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3 --n_clauses 10 --n_pairs 10 --target_dir 2_3_2_3_10_10 
python3 randQBFinc.py --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10 --n_clauses 80 --n_pairs 400 --target_dir 2_3_8_10_80_400

# to transform dimacs to pickle dump (need to find optimal max_node_per_batch to maximize the efficiency of GPU memory)
python3 dimacs_to_data.py  --dimacs_dir /homes/wang603/QBF/train10 --out_dir ./train10/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10

# to transform dimacs to pickle dump for train2_unsat and test2_unsat, predict forall vars
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train2_unsat --out_dir ./train2_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/test2_unsat --out_dir ./test2_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 2 -a 3
# to transform dimacs to pickle dump for train10_unsat and test10_unsat, predict forall vars
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/train10_unsat --out_dir ./train10_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10
python3 dimacs_to_data.py --dimacs_dir /homes/wang603/QBF/test10_unsat --out_dir ./test10_unsat/ --max_nodes_per_batch 5000 --n_quantifiers 2 -a 2 -a 3 -a 8 -a 10

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
