from sublime_plugin import WindowCommand
from .common import INPUT_GROUP
from .common import max_region
from .common import OUTPUT_GROUP
from .common import XSLT_GROUP

XSLT_EXAMPLE = '''\
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

	<xsl:template match="/">
		<h1>Hello</h1>
	</xsl:template>
</xsl:stylesheet>
'''


class XsltFiddleInsertExampleCommand(WindowCommand):

	def run(self):
		xslt_fiddle_window = self.window

		xslt_view = xslt_fiddle_window.active_view_in_group(XSLT_GROUP)
		xslt_view.run_command('xslt_fiddle_set_view_content', {'content': XSLT_EXAMPLE})
		xslt_view.sel().clear()

		input_view = xslt_fiddle_window.active_view_in_group(INPUT_GROUP)
		input_view.run_command('xslt_fiddle_set_view_content', {'content': '<root>content</root>'})
		input_view.sel().clear()
