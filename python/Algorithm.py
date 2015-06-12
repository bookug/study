#!/usr/bin/env python
# -*- coding: utf-8 -*-

# written by Kurt Wang (nirvanawgw@gmail.com)

from Generate import Generate

class Algorithm():
	"""
	Generate Sudoku Algorithm written by Kurt Wang
	"""

	generate = Generate()

	def solve(self, sudoku, count):
		"""
		solve problem
		"""

		if count == generate.NORMS * generate.NORMS:
			print 'Success'
			generate.printSudoku(sudoku)
			return

		row = count / 9
		col = count % 9
		if sudoku[row][col] == 0:
			# find constraints
			constraints = generate.getConstraints(sudoku, row, col)
			for constraint in constraints:
				# try one constraint
				sudoku[row][col] = constraint
				# next
				self.solve(sudoku, count + 1)

			# failed, back
			sudoku[row][col] = 0
		else:
			# next step
			self.solve(sudoku, count + 1)

if __name__ == "__main__":

	generate = Generate()
	sudoku = generate.generateGame(80)

	algorithm = Algorithm()
	algorithm.solve(sudoku, 0)