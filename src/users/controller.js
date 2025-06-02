import User from './model.js'

// Helpers para respuestas
const sendSuccess = (res, statusCode, data) => {
    res.status(statusCode).json({ isSuccess: true, data });
};

const sendError = (res, statusCode, message) => {
    res.status(statusCode).json({ isSuccess: false, error: message });
};

export const listUsers = async (req, res) => {
    try {
        const users = await User.findAll();
        return sendSuccess(res, 200, users);
    } catch (error) {
        console.error('listUsers() -> Internal Error:', error);
        return sendError(res, 500, 'Error listing users');
    }
};

export const getUser = async (req, res) => {
    try {
        const { id } = req.params;

        if (!id) {
            return sendError(res, 400, 'User ID is required');
        }

        const user = await User.findByPk(id);

        if (!user) {
            return sendError(res, 404, `User not found with ID: ${id}`);
        }

        return sendSuccess(res, 200, user);
    } catch (error) {
        console.error('getUser() -> Internal Error:', error);
        return sendError(res, 500, 'Error retrieving user');
    }
};

export const createUser = async (req, res) => {
    try {
        const { dni, ...userData } = req.body;

        if (!dni) {
            return sendError(res, 400, 'DNI is required');
        }

        const userExist = await User.findOne({ where: { dni } });

        if (userExist) {
            return sendError(res, 409, `User already exists with DNI: ${dni}`);
        }

        const user = await User.create({ dni, ...userData });

        return sendSuccess(res, 201, user);
    } catch (error) {
        console.error('createUser() -> Internal Error:', error);
        return sendError(res, 500, 'Error creating user');
    }
};
