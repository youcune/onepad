class PadModel
	attr_accessor(:id, :pid, :text, :status, :host, :agent, :saved_by, :saved_at, :saved_with, :is_deleted)
	
	def initialize(model)
		@id = model['id']
		@pid = model['pid']
		@text = model['text']
		@status = model['status']
		@host = model['host']
		@agent = model['agent']
		@saved_by = model['saved_by']
		@saved_at = model['saved_at']
		@saved_with = model['saved_with']
		@is_deleted = model['is_deleted']
	end
end
