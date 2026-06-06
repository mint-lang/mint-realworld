/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4287850865")

  // remove field
  collection.fields.removeById("bool1740301618")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4287850865")

  // add field
  collection.fields.addAt(5, new Field({
    "hidden": false,
    "id": "bool1740301618",
    "name": "favorited",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "bool"
  }))

  return app.save(collection)
})
