# Frontend Component Development Guide

This guide explains how to create and structure frontend components in the stock-app project.

## Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Component Structure](#component-structure)
- [Creating New Components](#creating-new-components)
- [Component Patterns](#component-patterns)
- [Routing and Navigation](#routing-and-navigation)
- [Styling Guidelines](#styling-guidelines)
- [Testing with Storybook](#testing-with-storybook)
- [Best Practices](#best-practices)
- [Examples](#examples)

## Project Overview

The stock-app is a Next.js 15 application built with TypeScript, using Material-UI Joy as the primary component library. The project follows a modular architecture with clear separation of concerns.

## Tech Stack

- **Framework**: Next.js 15 with App Router
- **Language**: TypeScript
- **UI Library**: Material-UI Joy (@mui/joy)
- **Icons**: Phosphor Icons (@phosphor-icons/react)
- **State Management**: React Query (@tanstack/react-query)
- **Forms**: React Hook Form with Zod validation
- **Styling**: Emotion (CSS-in-JS)
- **Testing**: Storybook
- **Package Manager**: pnpm

## Component Structure

The project follows a well-organized component structure:

```
src/
├── components/
│   ├── core/           # Reusable core components
│   ├── dashboard/      # Dashboard-specific components
│   ├── auth/           # Authentication components
│   └── marketing/      # Marketing page components
├── hooks/              # Custom React hooks
├── lib/                # Utility functions and configurations
├── types/              # TypeScript type definitions
└── stories/            # Storybook stories
```

## Creating New Components

### 1. Choose the Right Location

- **Core components** (`src/components/core/`): Reusable components used across the app
- **Dashboard components** (`src/components/dashboard/`): Components specific to dashboard functionality
- **Auth components** (`src/components/auth/`): Authentication-related components
- **Marketing components** (`src/components/marketing/`): Marketing page components

### 2. Component File Structure

Create your component with the following structure:

```typescript
// src/components/core/MyComponent.tsx
import * as React from 'react';
import { ComponentProps } from '@mui/joy/ComponentName';

export interface MyComponentProps extends ComponentProps {
  // Define your props here
  title: string;
  variant?: 'primary' | 'secondary';
  onAction?: () => void;
}

export function MyComponent({ 
  title, 
  variant = 'primary', 
  onAction,
  ...props 
}: MyComponentProps): React.JSX.Element {
  return (
    <div>
      {/* Your component JSX */}
    </div>
  );
}
```

### 3. Create Storybook Story

Create a corresponding Storybook story:

```typescript
// src/stories/MyComponent.stories.tsx
import type { Meta, StoryObj } from '@storybook/nextjs';
import React from 'react';
import { fn } from 'storybook/test';
import { MyComponent } from './MyComponent';

const meta = {
  title: 'Components/MyComponent',
  component: MyComponent,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['primary', 'secondary'],
    },
  },
  args: { onAction: fn() },
} satisfies Meta<typeof MyComponent>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    title: 'Primary Component',
    variant: 'primary',
  },
};

export const Secondary: Story = {
  args: {
    title: 'Secondary Component',
    variant: 'secondary',
  },
};
```

## Component Patterns

### 1. Basic Component Pattern

```typescript
import * as React from 'react';
import { ComponentProps } from '@mui/joy/ComponentName';

export interface MyComponentProps extends ComponentProps {
  // Props definition
}

export function MyComponent({ ...props }: MyComponentProps): React.JSX.Element {
  return (
    // Component JSX
  );
}
```

### 2. Dashboard Component Pattern

```typescript
'use client';

import * as React from 'react';
import { useSelection } from '@/hooks/use-selection';
import { DataTable } from '@/components/core/data-table';

export interface MyTableProps {
  rows: MyDataType[];
}

export function MyTable({ rows }: MyTableProps): React.JSX.Element {
  const rowIds = React.useMemo(() => rows.map((row) => row.id), [rows]);
  const selection = useSelection(rowIds);

  return (
    <DataTable
      // Table configuration
    />
  );
}
```

### 3. Form Component Pattern

```typescript
import * as React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  // Form validation schema
});

export interface MyFormProps {
  onSubmit: (data: FormData) => void;
}

export function MyForm({ onSubmit }: MyFormProps): React.JSX.Element {
  const { control, handleSubmit } = useForm({
    resolver: zodResolver(schema),
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Form fields */}
    </form>
  );
}
```

## Routing and Navigation

This section explains how to register routes and create menu items in the Next.js application.

### 1. Route Registration with Next.js App Router

The application uses Next.js 15 with the App Router, which uses file-based routing. Routes are automatically registered based on the file structure in the `src/app/` directory.

#### Basic Route Structure

```
src/app/
├── (marketing)/          # Route group (doesn't affect URL)
│   ├── layout.tsx        # Layout for marketing pages
│   └── page.tsx          # Home page (/)
├── auth/                 # Authentication routes
│   ├── sign-in/
│   │   └── page.tsx      # /auth/sign-in
│   └── sign-up/
│       └── page.tsx      # /auth/sign-up
└── dashboard/            # Dashboard routes
    ├── layout.tsx        # Dashboard layout
    ├── page.tsx          # /dashboard
    ├── users/
    │   └── page.tsx      # /dashboard/users
    └── [id]/             # Dynamic route
        └── page.tsx      # /dashboard/[id]
```

#### Creating a New Route

1. **Create the page file** in the appropriate directory:

```typescript
// src/app/dashboard/products/page.tsx
import * as React from 'react';
import type { Metadata } from 'next';
import { config } from '@/config';

export const metadata: Metadata = {
  title: `Products | Dashboard | ${config.site.name}`,
};

export default function ProductsPage(): React.JSX.Element {
  return (
    <div>
      <h1>Products</h1>
      {/* Your page content */}
    </div>
  );
}
```

2. **Add the route to paths.ts** for type safety and centralized path management:

```typescript
// src/paths.ts
export const paths = {
  // ... existing paths
  dashboard: {
    // ... existing dashboard paths
    products: {
      list: '/dashboard/products',
      create: '/dashboard/products/create',
      details: (productId: string) => `/dashboard/products/${productId}`,
    },
  },
} as const;
```

#### Dynamic Routes

For dynamic routes, use square brackets in the folder name:

```typescript
// src/app/dashboard/products/[id]/page.tsx
interface PageProps {
  params: { id: string };
}

export default function ProductDetailsPage({ params }: PageProps): React.JSX.Element {
  return (
    <div>
      <h1>Product Details: {params.id}</h1>
    </div>
  );
}
```

#### Route Groups

Use parentheses to create route groups without affecting the URL:

```
src/app/
├── (marketing)/          # Marketing pages group
│   ├── about/
│   └── contact/
└── (dashboard)/          # Dashboard pages group
    ├── users/
    └── products/
```

### 2. Navigation Configuration

The application uses a centralized navigation configuration system located in `src/components/dashboard/layout/config.ts`.

#### Navigation Structure

Navigation items are defined using the `NavItemConfig` interface:

```typescript
// src/types/nav.d.ts
export interface NavItemConfig {
  key: string;
  title?: string;
  disabled?: boolean;
  external?: boolean;
  icon?: string;
  href?: string;
  items?: NavItemConfig[];
  type?: 'divider';
  show?: (userInfo: { isSuperadmin?: boolean; isCustomerSuccess?: boolean }) => boolean;
  matcher?: { type: 'startsWith' | 'equals'; href: string };
}
```

#### Adding a New Menu Item

1. **Add the icon** to the nav-icons configuration:

```typescript
// src/components/dashboard/layout/nav-icons.ts
import { Package as PackageIcon } from '@phosphor-icons/react/dist/ssr/Package';

export const icons = {
  // ... existing icons
  'package': PackageIcon,
} as Record<string, Icon>;
```

2. **Add the menu item** to the layout configuration:

```typescript
// src/components/dashboard/layout/config.ts
export const layoutConfig: LayoutConfig = {
  navItems: [
    {
      key: 'dashboards',
      title: 'Dashboards',
      items: [
        // ... existing items
        { 
          key: 'products', 
          title: 'Products', 
          href: paths.dashboard.products.list, 
          icon: 'package' 
        },
      ],
    },
  ],
};
```

#### Creating Nested Menu Items

For dropdown menus with sub-items:

```typescript
{
  key: 'products',
  title: 'Products',
  icon: 'package',
  items: [
    { key: 'products-list', title: 'List Products', href: paths.dashboard.products.list },
    { key: 'products-create', title: 'Create Product', href: paths.dashboard.products.create },
  ],
}
```

#### Adding Dividers

Use dividers to separate menu sections:

```typescript
{
  key: 'divider1',
  type: 'divider',
  show: (userInfo) => userInfo.isSuperadmin || userInfo.isCustomerSuccess,
}
```

#### Role-Based Menu Items

Control menu item visibility based on user roles:

```typescript
{
  key: 'admin-only',
  title: 'Admin Panel',
  href: paths.dashboard.admin,
  icon: 'gear-six',
  show: (userInfo) => userInfo.isSuperadmin,
}
```

### 3. Page Layout and Metadata

#### Page Metadata

Always include proper metadata for SEO and browser display:

```typescript
import type { Metadata } from 'next';
import { config } from '@/config';

export const metadata: Metadata = {
  title: `Page Title | Dashboard | ${config.site.name}`,
  description: 'Page description for SEO',
};
```

#### Dashboard Layout

Dashboard pages automatically inherit the dashboard layout from `src/app/dashboard/layout.tsx`. This layout includes:

- Side navigation
- Main navigation header
- Authentication guard
- Responsive design

#### Custom Layouts

For pages that need different layouts, create a new layout file:

```typescript
// src/app/custom-layout/layout.tsx
export default function CustomLayout({
  children,
}: {
  children: React.ReactNode;
}): React.JSX.Element {
  return (
    <div>
      <h1>Custom Layout</h1>
      {children}
    </div>
  );
}
```

### 4. Navigation Patterns

#### Active State Detection

The navigation automatically detects active states using the `isNavItemActive` utility:

```typescript
// For exact matches
{ key: 'home', title: 'Home', href: '/dashboard' }

// For starts-with matches (useful for nested routes)
{ 
  key: 'products', 
  title: 'Products', 
  href: '/dashboard/products',
  matcher: { type: 'startsWith', href: '/dashboard/products' }
}
```

#### External Links

For external links, use the `external` property:

```typescript
{
  key: 'docs',
  title: 'Documentation',
  href: 'https://docs.example.com',
  external: true,
  icon: 'question',
}
```

#### Disabled Menu Items

Temporarily disable menu items:

```typescript
{
  key: 'coming-soon',
  title: 'Coming Soon',
  href: '#',
  disabled: true,
  icon: 'clock',
}
```

### 5. Best Practices

#### Route Organization

- Group related routes in folders
- Use descriptive folder and file names
- Keep route structure shallow when possible
- Use route groups for logical organization

#### Navigation Structure

- Keep menu items logically grouped
- Use consistent icon naming
- Implement proper role-based access control
- Provide clear visual hierarchy

#### Performance

- Use dynamic imports for heavy pages
- Implement proper loading states
- Optimize metadata for each page
- Use Next.js Image component for images

#### Accessibility

- Provide proper ARIA labels
- Ensure keyboard navigation works
- Use semantic HTML elements
- Test with screen readers

### 6. Common Patterns

#### Protected Routes

All dashboard routes are automatically protected by the `AuthGuard` component in the dashboard layout.

#### Modal Routes

Use Next.js parallel routes for modals:

```
src/app/dashboard/
├── @modal/
│   └── (..)modal/
│       └── [id]/
│           └── page.tsx
└── layout.tsx
```

#### Search and Filtering

Implement search and filtering in list pages:

```typescript
const [searchTerm, setSearchTerm] = useState('');
const [filters, setFilters] = useState({});

const { data } = useQuery({
  queryKey: ['items', searchTerm, filters],
  queryFn: () => getItems({ search: searchTerm, ...filters }),
});
```

## Styling Guidelines

### 1. Use Material-UI Joy Components

Prefer Joy UI components over custom HTML elements:

```typescript
// ✅ Good
import { Button, Card, Typography } from '@mui/joy';

// ❌ Avoid
<button>Click me</button>
```

### 2. Custom Styling with sx Prop

Use the `sx` prop for custom styling:

```typescript
<Button
  sx={{
    background: 'linear-gradient(120deg, #282490 0%, #3F4DCF 100%)',
    '&:hover': {
      background: 'linear-gradient(120deg, #1E1A6F 0%, #3439B0 100%)',
    },
  }}
>
  Click me
</Button>
```

### 3. CSS Variables

Use CSS variables for consistent theming:

```typescript
sx={{
  color: 'var(--joy-palette-text-primary)',
  backgroundColor: 'var(--joy-palette-background-mainBg)',
}}
```

### 4. Responsive Design

Use responsive breakpoints:

```typescript
sx={{
  display: { xs: 'none', lg: 'block' },
  width: { xs: '100%', md: '50%' },
}}
```

## Testing with Storybook

### 1. Run Storybook

```bash
pnpm storybook
```

### 2. Create Comprehensive Stories

Create stories for different component states:

```typescript
export const AllVariants: Story = {
  args: {
    label: 'Button',
  },
  render: () => (
    <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap' }}>
      <Button label="Primary" primary />
      <Button label="Secondary" variant="outlined" />
      <Button label="Plain" variant="plain" />
    </div>
  ),
};
```

### 3. Interactive Controls

Use Storybook controls for testing:

```typescript
argTypes: {
  variant: {
    control: { type: 'select' },
    options: ['primary', 'secondary', 'danger'],
  },
  size: {
    control: { type: 'select' },
    options: ['small', 'medium', 'large'],
  },
},
```

## Best Practices

### 1. TypeScript

- Always define proper interfaces for props
- Use `React.JSX.Element` as return type
- Extend existing component props when possible

### 2. Component Design

- Keep components focused and single-purpose
- Use composition over inheritance
- Make components reusable and configurable

### 3. Performance

- Use `React.useMemo` for expensive calculations
- Use `React.useCallback` for event handlers passed to children
- Implement proper key props for lists

### 4. Accessibility

- Use semantic HTML elements
- Provide proper ARIA labels
- Ensure keyboard navigation works

### 5. Code Organization

- Group related components in folders
- Use index files for clean imports
- Follow consistent naming conventions

## Examples

### Example 1: Simple Button Component

```typescript
// src/components/core/CustomButton.tsx
import * as React from 'react';
import { Button as JoyButton, ButtonProps as JoyButtonProps } from '@mui/joy';

export interface CustomButtonProps extends Omit<JoyButtonProps, 'variant' | 'color'> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  label: string;
}

export function CustomButton({ 
  variant = 'primary', 
  size = 'medium', 
  label,
  ...props 
}: CustomButtonProps): React.JSX.Element {
  return (
    <JoyButton
      variant="solid"
      color={variant === 'primary' ? 'primary' : variant === 'danger' ? 'danger' : 'neutral'}
      size={size === 'large' ? 'lg' : size === 'small' ? 'sm' : 'md'}
      {...props}
    >
      {label}
    </JoyButton>
  );
}
```

### Example 2: Data Table Component

```typescript
// src/components/dashboard/MyDataTable.tsx
'use client';

import * as React from 'react';
import { DataTable } from '@/components/core/data-table';
import { useSelection } from '@/hooks/use-selection';
import type { ColumnDef } from '@/components/core/data-table';

export interface MyData {
  id: string;
  name: string;
  email: string;
  status: 'active' | 'inactive';
}

const columns: ColumnDef<MyData>[] = [
  { field: 'id', name: 'ID', width: '100px' },
  { field: 'name', name: 'Name', width: '200px' },
  { field: 'email', name: 'Email', width: '250px' },
  { field: 'status', name: 'Status', width: '100px' },
];

export interface MyDataTableProps {
  rows: MyData[];
}

export function MyDataTable({ rows }: MyDataTableProps): React.JSX.Element {
  const rowIds = React.useMemo(() => rows.map((row) => row.id), [rows]);
  const selection = useSelection(rowIds);

  return (
    <DataTable
      columns={columns}
      rows={rows}
      selectable
      selected={selection.selected}
      onSelectAll={selection.selectAll}
      onDeselectAll={selection.deselectAll}
      onSelectOne={(_, row) => selection.selectOne(row.id)}
      onDeselectOne={(_, row) => selection.deselectOne(row.id)}
    />
  );
}
```

### Example 3: Form Component

```typescript
// src/components/forms/UserForm.tsx
import * as React from 'react';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button, Input, FormControl, FormLabel } from '@mui/joy';

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email address'),
});

type FormData = z.infer<typeof schema>;

export interface UserFormProps {
  onSubmit: (data: FormData) => void;
  initialData?: Partial<FormData>;
}

export function UserForm({ onSubmit, initialData }: UserFormProps): React.JSX.Element {
  const { control, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: initialData,
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <FormControl error={!!errors.name}>
        <FormLabel>Name</FormLabel>
        <Controller
          name="name"
          control={control}
          render={({ field }) => (
            <Input {...field} placeholder="Enter name" />
          )}
        />
      </FormControl>
      
      <FormControl error={!!errors.email}>
        <FormLabel>Email</FormLabel>
        <Controller
          name="email"
          control={control}
          render={({ field }) => (
            <Input {...field} type="email" placeholder="Enter email" />
          )}
        />
      </FormControl>
      
      <Button type="submit">Submit</Button>
    </form>
  );
}
```

### Example 4: Creating a New Route and Menu Item

This example shows how to create a complete "Reports" feature with routing and navigation.

#### Step 1: Add Route to paths.ts

```typescript
// src/paths.ts
export const paths = {
  // ... existing paths
  dashboard: {
    // ... existing dashboard paths
    reports: {
      list: '/dashboard/reports',
      create: '/dashboard/reports/create',
      details: (reportId: string) => `/dashboard/reports/${reportId}`,
      analytics: '/dashboard/reports/analytics',
    },
  },
} as const;
```

#### Step 2: Create the Page Component

```typescript
// src/app/dashboard/reports/page.tsx
"use client";

import * as React from 'react';
import type { Metadata } from 'next';
import Box from '@mui/joy/Box';
import Stack from '@mui/joy/Stack';
import Typography from '@mui/joy/Typography';
import Button from '@mui/joy/Button';
import { Plus as PlusIcon } from '@phosphor-icons/react/dist/ssr/Plus';
import { config } from '@/config';

const metadata: Metadata = {
  title: `Reports | Dashboard | ${config.site.name}`,
};

export default function ReportsPage(): React.JSX.Element {
  return (
    <Box sx={{ p: 'var(--Content-padding)' }}>
      <Stack spacing={3}>
        <Stack
          direction="row"
          spacing={2}
          sx={{ alignItems: 'center', justifyContent: 'space-between' }}
        >
          <Typography fontSize="xl3" level="h1">
            Reports
          </Typography>
          <Button
            variant="solid"
            color="primary"
            startDecorator={<PlusIcon />}
            href="/dashboard/reports/create"
          >
            Create Report
          </Button>
        </Stack>
        
        <Box>
          <Typography level="body-md" color="neutral">
            Your reports will appear here.
          </Typography>
        </Box>
      </Stack>
    </Box>
  );
}
```

#### Step 3: Add Icon to Navigation

```typescript
// src/components/dashboard/layout/nav-icons.ts
import { ChartBar as ChartBarIcon } from '@phosphor-icons/react/dist/ssr/ChartBar';

export const icons = {
  // ... existing icons
  'chart-bar': ChartBarIcon,
} as Record<string, Icon>;
```

#### Step 4: Add Menu Item to Navigation

```typescript
// src/components/dashboard/layout/config.ts
export const layoutConfig: LayoutConfig = {
  navItems: [
    {
      key: 'dashboards',
      title: 'Dashboards',
      items: [
        // ... existing items
        { 
          key: 'reports', 
          title: 'Reports', 
          href: paths.dashboard.reports.list, 
          icon: 'chart-bar',
          matcher: { type: 'startsWith', href: '/dashboard/reports' }
        },
      ],
    },
  ],
};
```

### Example 5: Creating a Nested Menu with Sub-items

This example shows how to create a "Settings" menu with multiple sub-items.

#### Step 1: Define Nested Routes

```typescript
// src/paths.ts
export const paths = {
  dashboard: {
    settings: {
      general: '/dashboard/settings',
      profile: '/dashboard/settings/profile',
      security: '/dashboard/settings/security',
      notifications: '/dashboard/settings/notifications',
      billing: '/dashboard/settings/billing',
    },
  },
} as const;
```

#### Step 2: Create Nested Menu Structure

```typescript
// src/components/dashboard/layout/config.ts
export const layoutConfig: LayoutConfig = {
  navItems: [
    {
      key: 'dashboards',
      title: 'Dashboards',
      items: [
        // ... existing items
        {
          key: 'settings',
          title: 'Settings',
          icon: 'gear-six',
          matcher: { type: 'startsWith', href: '/dashboard/settings' },
          items: [
            { 
              key: 'settings-general', 
              title: 'General', 
              href: paths.dashboard.settings.general 
            },
            { 
              key: 'settings-profile', 
              title: 'Profile', 
              href: paths.dashboard.settings.profile 
            },
            { 
              key: 'settings-security', 
              title: 'Security', 
              href: paths.dashboard.settings.security 
            },
            { 
              key: 'settings-notifications', 
              title: 'Notifications', 
              href: paths.dashboard.settings.notifications 
            },
            { 
              key: 'settings-billing', 
              title: 'Billing', 
              href: paths.dashboard.settings.billing 
            },
          ],
        },
      ],
    },
  ],
};
```

### Example 6: Role-Based Menu Items

This example shows how to create menu items that are only visible to certain user roles.

```typescript
// src/components/dashboard/layout/config.ts
export const layoutConfig: LayoutConfig = {
  navItems: [
    {
      key: 'dashboards',
      title: 'Dashboards',
      items: [
        // ... existing items
        
        // Admin-only menu item
        {
          key: 'admin-panel',
          title: 'Admin Panel',
          href: paths.dashboard.admin,
          icon: 'gear-six',
          show: (userInfo) => userInfo.isSuperadmin,
        },
        
        // Customer Success and Admin menu item
        {
          key: 'customer-support',
          title: 'Customer Support',
          href: paths.dashboard.support,
          icon: 'headphones',
          show: (userInfo) => userInfo.isSuperadmin || userInfo.isCustomerSuccess,
        },
        
        // Divider for role-based sections
        {
          key: 'divider-admin',
          type: 'divider',
          show: (userInfo) => userInfo.isSuperadmin || userInfo.isCustomerSuccess,
        },
      ],
    },
  ],
};
```

## Development Workflow

### For Components

1. **Plan your component**: Define props, behavior, and styling requirements
2. **Create the component file**: Follow the established patterns
3. **Write TypeScript interfaces**: Define clear prop types
4. **Implement the component**: Use Joy UI components and proper styling
5. **Create Storybook stories**: Test different states and configurations
6. **Test in Storybook**: Verify component behavior and appearance
7. **Integrate into the app**: Use the component in your pages/features
8. **Document usage**: Add JSDoc comments for complex props

### For New Pages/Routes

1. **Plan your feature**: Define the page structure, data requirements, and user interactions
2. **Add routes to paths.ts**: Define all related routes for type safety
3. **Create page components**: Implement the main page and any sub-pages
4. **Add navigation items**: Update the navigation configuration
5. **Add icons**: Register any new icons in the nav-icons configuration
6. **Implement role-based access**: Add proper permission checks if needed
7. **Test navigation**: Verify menu items work correctly and show proper active states
8. **Add metadata**: Include proper page titles and descriptions

### For Navigation Updates

1. **Identify the change**: Determine what needs to be added, modified, or removed
2. **Update nav-icons.ts**: Add any new icons needed
3. **Modify config.ts**: Update the navigation configuration
4. **Test role-based visibility**: Ensure menu items show/hide correctly based on user roles
5. **Verify active states**: Check that navigation highlighting works properly
6. **Test responsive behavior**: Ensure navigation works on mobile and desktop

## Resources

- [Material-UI Joy Documentation](https://mui.com/joy-ui/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Storybook Documentation](https://storybook.js.org/docs)
- [React Hook Form Documentation](https://react-hook-form.com/)
- [Zod Documentation](https://zod.dev/)

---

This guide should help you create consistent, maintainable, and well-tested components in the stock-app project. For questions or clarifications, refer to existing components in the codebase or consult the team.
