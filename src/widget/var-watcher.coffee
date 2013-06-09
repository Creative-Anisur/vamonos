#_require ../common.coffee

class VarWatcher
    
    constructor: ({container, watch, showChanges}) ->
        @$container = Common.jqueryify(container)
        @watch      = Common.arrayify(watch)
        @hidden     = yes
#        @$container.hide()

        @showChanges = Common.arrayify(showChanges ? "next")

    event: (event, options...) -> switch event
        when "setup"
            [@stash, vis] = options
            @stash[v] = null for v in @watch

            @$table = $("<table>", {class: "var-watcher"})

            @tblRows = {}
            for v in @watch
                @tblRows[v] = $("<tr>").append(
                    $("<td>", {text: v}),
                    $("<td>", {text: "="}),
                    $("<td>", {text: ""})
                )
                @$table.append(@tblRows[v])
                        
            @$container.html(@$table)

        when "editStop"
            @stash[v] = null for v in @watch
            
        when "render"
            @showVars(options...)

#        when "displayStart"
#            @show()

        when "displayStop"
#            @hide()
            @clear()
#            showVars({}, "none")

    showVars: (frame, type) ->
#        @clear()
        for v in @watch
            newval = if frame[v]? then Common.rawToTxt(frame[v]) else "<i>undef</i>"
            cell = @tblRows[v].find("td:nth-child(3)")
            oldval = cell.html()
            if newval isnt oldval and type in @showChanges
                @tblRows[v].addClass("changed")
                cell.html(newval)
                newrow = @tblRows[v].clone()
                @tblRows[v].replaceWith( newrow )
                @tblRows[v] = newrow
            else
                cell.html(newval)
                @tblRows[v].removeClass("changed")

    clear: ->
        e.find("td:nth-child(3)").html("") for v,e of @tblRows

    hide: ->
        @$container.slideUp()

    show: ->
        @$container.show() if @hidden
        @$container.slideDown()



Common.VamonosExport { Widget: { VarWatcher } }
