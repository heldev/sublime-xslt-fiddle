import sublime
from sublime_plugin import ApplicationCommand

from .common import XSLT_GROUP
from .common import INPUT_GROUP
from .common import OUTPUT_GROUP

LAYOUT = {
	'cells': [
		[0, 0, 1, 2],
		[1, 0, 2, 1],
		[1, 1, 2, 2]
	],
	'cols': [0.0, 0.62, 1.0],
	'rows': [0.0, 0.38, 1.0]
}

class XsltFiddleNewWindowCommand(ApplicationCommand):

	def run(self):
		window = self.create_window()
		self.create_views(window)
		window.run_command('xslt_fiddle_insert_example')


	def create_window(self):
		sublime.run_command('new_window')
		window = sublime.active_window()
		window.set_tabs_visible(False)
		window.set_sidebar_visible(False)

		window.run_command('set_layout', LAYOUT)

		return window


	def create_views(self, window):
		for group in [XSLT_GROUP, INPUT_GROUP, OUTPUT_GROUP]:
			self.create_xml_view(window, group)

		window.focus_group(XSLT_GROUP)

		for view in window.views_in_group(OUTPUT_GROUP):
			view.set_scratch(True)


	def create_xml_view(self, window, group):
		view = window.new_file()
		view.settings().set('xslt_fiddle_view_tag', '')
		view.set_syntax_file('Packages/XML/XML.sublime-syntax')
		window.set_view_index(view, group, 0)

		return view
