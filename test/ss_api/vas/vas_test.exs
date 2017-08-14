defmodule SsApi.VasTest do
  use SsApi.DataCase

  alias SsApi.Vas

  describe "operators" do
    alias SsApi.Vas.Operator

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def operator_fixture(attrs \\ %{}) do
      {:ok, operator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vas.create_operator()

      operator
    end

    test "list_operators/0 returns all operators" do
      operator = operator_fixture()
      assert Vas.list_operators() == [operator]
    end

    test "get_operator!/1 returns the operator with given id" do
      operator = operator_fixture()
      assert Vas.get_operator!(operator.id) == operator
    end

    test "create_operator/1 with valid data creates a operator" do
      assert {:ok, %Operator{} = operator} = Vas.create_operator(@valid_attrs)
      assert operator.name == "some name"
    end

    test "create_operator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vas.create_operator(@invalid_attrs)
    end

    test "update_operator/2 with valid data updates the operator" do
      operator = operator_fixture()
      assert {:ok, operator} = Vas.update_operator(operator, @update_attrs)
      assert %Operator{} = operator
      assert operator.name == "some updated name"
    end

    test "update_operator/2 with invalid data returns error changeset" do
      operator = operator_fixture()
      assert {:error, %Ecto.Changeset{}} = Vas.update_operator(operator, @invalid_attrs)
      assert operator == Vas.get_operator!(operator.id)
    end

    test "delete_operator/1 deletes the operator" do
      operator = operator_fixture()
      assert {:ok, %Operator{}} = Vas.delete_operator(operator)
      assert_raise Ecto.NoResultsError, fn -> Vas.get_operator!(operator.id) end
    end

    test "change_operator/1 returns a operator changeset" do
      operator = operator_fixture()
      assert %Ecto.Changeset{} = Vas.change_operator(operator)
    end
  end

  describe "types" do
    alias SsApi.Vas.Type

    @valid_attrs %{eng_name: "some eng_name", has_sub_cat: "some has_sub_cat", name: "some name"}
    @update_attrs %{eng_name: "some updated eng_name", has_sub_cat: "some updated has_sub_cat", name: "some updated name"}
    @invalid_attrs %{eng_name: nil, has_sub_cat: nil, name: nil}

    def type_fixture(attrs \\ %{}) do
      {:ok, type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vas.create_type()

      type
    end

    test "list_types/0 returns all types" do
      type = type_fixture()
      assert Vas.list_types() == [type]
    end

    test "get_type!/1 returns the type with given id" do
      type = type_fixture()
      assert Vas.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      assert {:ok, %Type{} = type} = Vas.create_type(@valid_attrs)
      assert type.eng_name == "some eng_name"
      assert type.has_sub_cat == "some has_sub_cat"
      assert type.name == "some name"
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vas.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      type = type_fixture()
      assert {:ok, type} = Vas.update_type(type, @update_attrs)
      assert %Type{} = type
      assert type.eng_name == "some updated eng_name"
      assert type.has_sub_cat == "some updated has_sub_cat"
      assert type.name == "some updated name"
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Vas.update_type(type, @invalid_attrs)
      assert type == Vas.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      type = type_fixture()
      assert {:ok, %Type{}} = Vas.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Vas.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      type = type_fixture()
      assert %Ecto.Changeset{} = Vas.change_type(type)
    end
  end

  describe "categories" do
    alias SsApi.Vas.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vas.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Vas.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Vas.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Vas.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vas.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Vas.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Vas.update_category(category, @invalid_attrs)
      assert category == Vas.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Vas.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Vas.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Vas.change_category(category)
    end
  end

  describe "services" do
    alias SsApi.Vas.Service

    @valid_attrs %{description: "some description", expire_after: "some expire_after", filename: "some filename", help: "some help", like: "some like", meta: "some meta", name: "some name", picture: "some picture", price: "some price", run: "some run", tags: "some tags", view: "some view"}
    @update_attrs %{description: "some updated description", expire_after: "some updated expire_after", filename: "some updated filename", help: "some updated help", like: "some updated like", meta: "some updated meta", name: "some updated name", picture: "some updated picture", price: "some updated price", run: "some updated run", tags: "some updated tags", view: "some updated view"}
    @invalid_attrs %{description: nil, expire_after: nil, filename: nil, help: nil, like: nil, meta: nil, name: nil, picture: nil, price: nil, run: nil, tags: nil, view: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vas.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Vas.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Vas.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Vas.create_service(@valid_attrs)
      assert service.description == "some description"
      assert service.expire_after == "some expire_after"
      assert service.filename == "some filename"
      assert service.help == "some help"
      assert service.like == "some like"
      assert service.meta == "some meta"
      assert service.name == "some name"
      assert service.picture == "some picture"
      assert service.price == "some price"
      assert service.run == "some run"
      assert service.tags == "some tags"
      assert service.view == "some view"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vas.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, service} = Vas.update_service(service, @update_attrs)
      assert %Service{} = service
      assert service.description == "some updated description"
      assert service.expire_after == "some updated expire_after"
      assert service.filename == "some updated filename"
      assert service.help == "some updated help"
      assert service.like == "some updated like"
      assert service.meta == "some updated meta"
      assert service.name == "some updated name"
      assert service.picture == "some updated picture"
      assert service.price == "some updated price"
      assert service.run == "some updated run"
      assert service.tags == "some updated tags"
      assert service.view == "some updated view"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Vas.update_service(service, @invalid_attrs)
      assert service == Vas.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Vas.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Vas.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Vas.change_service(service)
    end
  end
end
