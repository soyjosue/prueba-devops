import sequelize from './shared/database/database.js'
import { usersRouter } from "./users/router.js"
import express from 'express'

const app = express()
const PORT = 8000

sequelize.sync({ force: true }).then(() => console.log('db is ready'))

app.use(express.json())
app.use('/api/users', usersRouter)

app.get('/_health', (_, res) => {
    res.status(200).send('OK');
})

const server = app.listen(PORT, () => {
    console.log('Server running on port PORT', PORT)
})

export { app, server }