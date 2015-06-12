#!/usr/bin/env python
# -*- coding: utf-8 -*-

# written by Kurt Wang (nirvanawgw@gmail.com)

from random import choice
import random

class Generate():
	"""
	Generate Sudoku written by Kurt Wang
	"""

	NORMS = 9

	CELL = 3

	EMPTY = 0

	sudoku_copy = [[EMPTY for x in range(NORMS)] for y in range(NORMS)]

	def printSudoku(self, sudoku):
		"""
		print Sudoku as human readable
		"""

		text = ''
		for row in range(self.NORMS):
			for col in range(self.NORMS):
				text = text + str(sudoku[row][col]) + ' '
				if (col + 1) % self.NORMS == 0:
					text = text + '\n'
		print text

	def generateGame(self, removeCount):
		"""
		generate a Sudoku game
		"""

		sudoku = self.generateSudoku()
		for i in range(removeCount):
			row = random.randint(0, self.NORMS - 1)
			col = random.randint(0, self.NORMS - 1)
			sudoku[row][col] = self.EMPTY

		self.printSudoku(sudoku)
		return sudoku

	def generateSudoku(self):
		"""
		geneate Sudoku
		"""

		# create empty Sudoku
		sudoku = [[self.EMPTY for x in range(self.NORMS)] for y in range(self.NORMS)]

		# save current un-modify status
		self.copySudoku(sudoku, self.sudoku_copy)

		while(not self.generate(sudoku)):
			pass

		self.printSudoku(sudoku)
		return sudoku

	def generate(self, sudoku):
		"""
		genearte Sudoku, if there is no suitable constraints, return False
		"""

		# reset sudoku to un-modify
		sudoku = self.copySudoku(self.sudoku_copy, sudoku)

		for row in range(self.NORMS):
			for col in range(self.NORMS):
				# get constraints for point sudoku[row][col]
				constraints =  self.getConstraints(sudoku, row, col)
				if len(constraints) == 0:
					# nothing to select, return False
					return False

				# random select one from constraints
				sudoku[row][col] = int(choice(constraints))	
		return True

	def copySudoku(self, source, dist):
		"""
		create a deep copy of sudoku
		"""

		for row in range(self.NORMS):
			for col in range(self.NORMS):
				dist[row][col] = source[row][col]
		return dist

	def getConstraints(self, sudoku, row, col):
		"""
		return constraints for given row, col
		"""

		constraints = set([1, 2, 3, 4, 5, 6, 7, 8, 9])

		# remove row
		constraints = self.removeRowConflict(sudoku, constraints, row)

		# remove col
		constraints = self.removeColConflict(sudoku, constraints, col)

		# remove 3x3 cell
		constraints = self.removeCellConflict(sudoku, constraints, row, col)

		return list(constraints)

	def removeRowConflict(self, sudoku, constraints, row):
		"""
		remove confilct in row
		"""

		return constraints - set(sudoku[row])

	def removeColConflict(self, sudoku, constraints, col):
		"""
		remove confilct in col
		"""

		colList = []
		for i in range(self.NORMS):
			for j in range(self.NORMS):
				if j == col:
					colList.append(sudoku[i][j])

		return constraints - set(colList)

	def removeCellConflict(self, sudoku, constraints, row, col):
		"""
		remove confilct in cell
		"""

		cellList = []

		# cell start index
		rowCell = row / self.CELL * self.CELL
		colCell = col / self.CELL * self.CELL

		for i in range(rowCell, rowCell + self.CELL):
			for j in range(colCell, colCell + self.CELL):
				cellList.append(sudoku[i][j])

		return constraints - set(cellList)

if __name__ == "__main__":

	generate = Generate()
	generate.generateGame(80)