const router = require('koa-router')()

router.get('/', async (ctx, next) => {
  await ctx.render('index.html')
})

module.exports = router
