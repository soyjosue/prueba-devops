import { app, server } from ".";
import request from "supertest";
import User from "./users/model.js";

describe("User Controller", () => {
  const userData = {
    dni: "1234567890",
    name: "Test",
  };

  afterEach(() => {
    jest.clearAllMocks();
  });

  afterAll(() => {
    server.close();
  });

  test("GET /api/users -> should return list of users", async () => {
    jest.spyOn(User, "findAll").mockResolvedValue([userData]);

    const response = await request(app).get("/api/users");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      isSuccess: true,
      data: [userData],
    });
  });

  test("GET /api/users/:id -> should return a user by id", async () => {
    const expectedUser = { ...userData, id: 1 };
    jest.spyOn(User, "findByPk").mockResolvedValue(expectedUser);

    const response = await request(app).get("/api/users/1");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      isSuccess: true,
      data: expectedUser,
    });
  });

  test("GET /api/users/:id -> should return 404 if user not found", async () => {
    jest.spyOn(User, "findByPk").mockResolvedValue(null);

    const response = await request(app).get("/api/users/99");

    expect(response.status).toBe(404);
    expect(response.body).toEqual({
      isSuccess: false,
      error: "User not found with ID: 99",
    });
  });

  test("POST /api/users -> should create a new user", async () => {
    const createdUser = { ...userData, id: 1 };

    jest.spyOn(User, "findOne").mockResolvedValue(null);
    jest.spyOn(User, "create").mockResolvedValue(createdUser);

    const response = await request(app).post("/api/users").send(userData);

    expect(response.status).toBe(201);
    expect(response.body).toEqual({
      isSuccess: true,
      data: createdUser,
    });
  });

  test("POST /api/users -> should return 409 if user already exists", async () => {
    jest.spyOn(User, "findOne").mockResolvedValue(userData);

    const response = await request(app).post("/api/users").send(userData);

    expect(response.status).toBe(409);
    expect(response.body).toEqual({
      isSuccess: false,
      error: `User already exists with DNI: ${userData.dni}`,
    });
  });

  test("POST /api/users -> should return 400 if dni is missing", async () => {
    const response = await request(app)
      .post("/api/users")
      .send({ name: "NoDNI" });

    expect(response.status).toBe(400);
    expect(response.body).toMatchObject({
      errors: expect.arrayContaining([
        expect.objectContaining({
          message: expect.stringContaining("dni"),
          path: "body.dni",
        }),
      ]),
    });
  });
});
