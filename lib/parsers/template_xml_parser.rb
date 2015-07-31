module Parsers
  class TemplateXmlParser

    def parse(template_element)
      template = Template.new
      template.raw_xml = template_element ? template_element.children.to_s : '*'
      template
    end
  end
end
