open OUnit2

let suite = test_list [Test_refined.suite]

let () = run_test_tt_main suite

