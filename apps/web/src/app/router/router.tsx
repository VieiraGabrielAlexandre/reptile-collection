import { createBrowserRouter } from "react-router-dom";
import { PublicLayout } from "../../components/layout/PublicLayout";
import { HomePage } from "../../features/home/pages/HomePage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: (
      <PublicLayout>
        <HomePage />
      </PublicLayout>
    ),
  },
]);
