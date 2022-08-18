# frozen_string_literal: true
class BacklinksGenerator < Jekyll::Generator
    """
    Class to add backlinks to notes metadata
    """
    def generate(site)
        graph_nodes = []
        graph_edges = []

        all_notes = site.collections['notes'].docs
        # Identify note backlinks and add them to each note
        all_notes.each do |current_note|
            # Nodes: Jekyll
            notes_linking_to_current_note = all_notes.filter do |e|
                e.content.include?(current_note.url)
            end

            # Nodes: Graph
            graph_nodes << {
                id: current_note.url,
                title: current_note.data['title'],
            }
    
            # Edges: Jekyll
            current_note.data['backlinks'] = notes_linking_to_current_note

            # Edges: Graph
            notes_linking_to_current_note.each do |n|
                graph_edges << {
                    source: n.url,
                    target: current_note.url,
                }
            end
        end

        # put information in site.data to pass to graph.json
        site.data['graph_nodes'] = graph_nodes
        site.data['graph_edges'] = graph_edges
    end
end
