
module.exports = window.App = Ember.Application.create()

App.Router.map ->
  @resource "chat", { path: "/chat/:name" }

App.ChatsArray = Ember.ArrayProxy.extend
  init: ->
    @chats = Ember.A()
    @set("content", @chats)

    @_super()

  # created this to avoid overwriting find, until i understand this better
  getChat: (data) ->
    chat = App.chats.findBy("name", data.name)
    unless chat?
      chat = App.chats.joinChat(data)

    # why is this returning undefined?
    console.log "after", chat
    return chat


  joinChat: (data) ->
    chat = App.MessagesArray.create(data)
    @chats.pushObject(chat)
    return chat

  addMessage: (data) ->
    console.log "yep"

App.MessagesArray = Ember.ArrayProxy.extend
  init: (data) ->
    console.log "App.MessagesArray::init", this.name
    messages = Ember.A()
    @set("content", messages)

    @_super()


App.chats = App.ChatsArray.create()


# ChatController
App.ChatTabsController = Ember.ArrayController.extend


# ChatController
App.ChatController = Ember.ArrayController.extend
  needs: "application"
  msg: ""
  actions:
    sendMessage: ->
      console.log "ACTIVE", this
      @pushObject(this.get("msg"))
      @set("msg", "")

# ChatRoute
App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    messages = App.chats.getChat({name: params.name})
    return messages

# ScrollingDivComponent
App.ScrollingDivComponent = Ember.Component.extend
  scheduleScrollIntoView: (->
    Ember.run.scheduleOnce("afterRender", this, "scrollIntoView")
  ).observes("update-when.@each")

  scrollIntoView: ->
    this.$().scrollTop(this.$().prop("scrollHeight"))

# ChatTabsView
App.ChatTabsView = Ember.CollectionView.extend
  classNames: ["chat-tabs-thing"]
  content: ["hi", "no"]
  itemViewClass: App.ChatTabView

App.ChatTabView = Ember.View.extend
  templateName: "chat-tabs"



