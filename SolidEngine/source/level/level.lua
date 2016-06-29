level = {
  new = function()
    return {
      objects = {},
      
      addObject = function(self, obj)
        table.insert(self.objects, obj)
      end
    }
  end
}