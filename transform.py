import os
from os import fdopen
from subprocess import PIPE
from subprocess import Popen
from tempfile import mkstemp

from sublime_plugin import WindowCommand

from .common import max_region
from .common import XSLT_GROUP
from .common import INPUT_GROUP
from .common import OUTPUT_GROUP


class XsltFiddleTransformCommand(WindowCommand):

	def run(self):
		window = self.window

		output, errors = self.get_transformation_outputs(window)

		if output:
			output_view = window.active_view_in_group(OUTPUT_GROUP)
			output_view.set_read_only(False)
			output_view.run_command('xslt_fiddle_set_view_content', {'content': output.decode()})
			output_view.set_read_only(True)

			for group in {OUTPUT_GROUP, XSLT_GROUP}:
				window.active_view_in_group(group) \
						.hide_popup()

		else:

			window.active_view_in_group(OUTPUT_GROUP) \
					.show_popup(errors.decode())


	def get_transformation_outputs(self, window):
		xslt_view = window.active_view_in_group(XSLT_GROUP)
		xslt_path = self.get_content_as_temporary_file(xslt_view)

		input_view = window.active_view_in_group(INPUT_GROUP)
		input_path = self.get_content_as_temporary_file(input_view)

		saxon = Popen(
				['saxon', input_path, xslt_path],
				stdout=PIPE,
				stderr=PIPE)

		output, errors = saxon.communicate()

		os.remove(xslt_path)
		os.remove(input_path)

		return output, errors


	def get_content_as_temporary_file(self, view):
		handle, path = mkstemp()
		with fdopen(handle, 'wb') as file:
			content = view.substr(max_region(view))
			file.write(content.encode())

		return path

