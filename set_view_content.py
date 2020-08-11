from sublime_plugin import TextCommand

from .common import max_region

class XsltFiddleSetViewContentCommand(TextCommand):

	def run(self, edit, content):
		self.view.replace(edit, max_region(self.view), content)
