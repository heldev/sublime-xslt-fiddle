from itertools import chain

import sublime

from sublime_plugin import EventListener

from .common import XSLT_GROUP
from .common import INPUT_GROUP


class Listener(EventListener):

	def __init__(self):
		self.x = {}


	def on_activated_async(self, view):
		if self.is_xslt_or_input_view(view):
			view.window().run_command('xslt_fiddle_transform')


	def on_modified(self, view):
		return
		if self.is_xslt_or_input_view(view):
			changes_during_last_modification = view.change_count()

			sublime.set_timeout(
					lambda: self.update_if_not_changed(view.id(), changes_during_last_modification),
					500)


	def is_xslt_or_input_view(self, view):

		return self.is_xslt_fiddle_view(view) \
				and view.window().get_view_index(view)[0] in {XSLT_GROUP, INPUT_GROUP}


	def update_if_not_changed(self, view_id, changes_during_last_modification):
		views = chain.from_iterable(map(lambda window: window.views(), sublime.windows()))
		view = next(filter(lambda view: view.id() == view_id, views), None)

		if view and changes_during_last_modification == view.change_count():
			view.window().run_command('xslt_fiddle_transform')


	def on_new(self, view):
		if self.is_xslt_fiddle_window(view.window()):
			view.settings().set('xslt_fiddle_view_tag', None)


	def on_pre_close(self, view):
		if self.is_last_view_in_xslt_fiddle_window(view):
			self.x[view.id()] = view.window()


	def is_last_view_in_xslt_fiddle_window(self, view):
		window = view.window()

		return window \
				and window.get_view_index(view)[1] != -1 \
				and self.is_xslt_fiddle_window(window) \
				and len(window.views()) == 1


	def on_close(self, view):
		view_id = view.id()
		if view_id in self.x:
			self.x[view_id].run_command('close_window')
			del self.x[view_id]


	def is_xslt_fiddle_window(self, window):
		return any(map(self.is_xslt_fiddle_view, window.views()))


	def is_xslt_fiddle_view(self, view):

		return view.window() \
				and view.settings().has('xslt_fiddle_view_tag')
